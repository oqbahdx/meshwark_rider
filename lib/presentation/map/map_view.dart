import 'dart:async';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meshwark_rider/presentation/resources/Strings_manager.dart';
import 'package:meshwark_rider/presentation/resources/fonts_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lottie/lottie.dart' as lot;
import 'package:vibration/vibration.dart';

import '../../app/constants.dart';
import '../../data/network/dio_helper.dart';
import '../../data/network/signalR_service.dart';
import '../../domain/all_drivers_model.dart'; // Contains GetAllDriversModel and Data
import '../bloc/map_bloc/map_cubit.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/language_manager.dart';
import '../resources/value_manager.dart';
import '../trip_information.dart';

class MapPageView extends StatefulWidget {
  final String image;
  final String tag;
  final String gender;
  final String typeOfTrip;

  const MapPageView({
    super.key,
    required this.image,
    required this.tag,
    required this.gender,
    required this.typeOfTrip,
  });

  @override
  State<MapPageView> createState() => _MapPageViewState();
}

class _MapPageViewState extends State<MapPageView> {
  final SignalRService _signalRService = SignalRService();
  late StreamSubscription<List<Data>> _driverUpdateSubscription;
  late StreamSubscription<bool> _driverResponseSubscription;
  final Map<String, Marker> _markers = {};
  GoogleMapController? _mapController;
  Uint8List? imageData;
  String? _mapStyle;
  Data? _selectedDriver;
  bool isOrderAccepted = false;
  ScrollController scrollController = ScrollController();
  final Completer<GoogleMapController> _controller = Completer();
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  TextEditingController? priceController;
  TextEditingController? passengersController;

  @override
  void initState() {
    super.initState();
    // Inside initState()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          const LatLng(30.0113008, 31.1728897),
          16.0,
        ),
      );
    });
    _initializeSignalRAndListeners();
    fetchInitialData();

    rootBundle.loadString('assets/map/map_style.txt').then((value) {
      setState(() {
        _mapStyle = value;
      });
    });

    priceController = TextEditingController();
    passengersController = TextEditingController();

    Geolocator.getCurrentPosition().then((currLocation) {
      setState(() {
        context.read<MapCubit>().currentLatLng =
            LatLng(currLocation.latitude, currLocation.longitude);
      });
    });
    takeMeToMyLocation();
  }

  Future<void> _initializeSignalRAndListeners() async {
    await _signalRService.initSignalR();
    _listenForDriverUpdates();
    _listenForDriverResponse();
  }

  void _listenForDriverResponse() {
    _driverResponseSubscription = _signalRService.driverResponseStream.listen(
      (accepted) {
       
        if (mounted) {
          setState(() {
            if (accepted) {
              _showAcceptedDialog(context);
            } else {
              _showRejectedDialog(context);
            }
          });
        }
      },
      onError: (error) {
      
      },
    );
   
  }

  // Change subscription to listen for a list of Data instead of GetAllDriversModel
  void _listenForDriverUpdates() {
    _driverUpdateSubscription = _signalRService.stream.listen(
      (driversData) {
        setState(() {
          _markers.clear();
          _updateMarkersBatch(driversData);
        });
      },
      onError: (error) {
       
      },
    );
  }

  void _removeMarker(String driverId) {
    setState(() {
      _markers.remove(driverId);
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    _customInfoWindowController.googleMapController = controller;
    imageData = await context
        .read<MapCubit>()
        .getBytesFromAsset('assets/icons/appLogoSplash.png', context);
    if (mounted) {
      setState(() {
        _mapController = controller;
        controller.setMapStyle(_mapStyle).then((_) {
          setState(() {
            _mapController = controller;
          });
        });
      });
    }
  }

  // Accept a list of Data objects (each representing a driver)
void _updateMarkersBatch(List<Data> drivers) {
  final newMarkers = <String, Marker>{};
  for (var driver in drivers) {
    if (_shouldShowDriver(driver)) {
      newMarkers[driver.id!] = _createMarker(driver);
    }
  }
  if (mounted) {
    setState(() {
      _markers.removeWhere((id, _) => !newMarkers.containsKey(id));
      _markers.addAll(newMarkers);
    });
  }
}

bool _shouldShowDriver(Data driver) {
  final isValid = driver.isOnline == true &&
      driver.gender == widget.gender &&
      driver.latitude != null &&
      driver.longitude != null;
 
  return isValid;
}

  Marker _createMarker(Data driver) {
    return Marker(
      markerId: MarkerId(driver.id ?? ""),
      position: LatLng(
        driver.latitude?.toDouble() ?? 0.0,
        driver.longitude?.toDouble() ?? 0.0,
      ),
      // icon: BitmapDescriptor.fromBytes(imageData!),
      icon: BitmapDescriptor.bytes(imageData!),
      onTap: () {
        setState(() {
          _selectedDriver = driver;
        });
        context.read<MapCubit>().showDriverDetailsDialog(context, driver);
      },
    );
  }

  void _updateMarker(Data driver) {
    if (driver.isOnline == true && driver.gender == widget.gender) {
      final markerId = driver.id ?? "";
      final marker = Marker(
        markerId: MarkerId(markerId),
        position: LatLng(
          driver.latitude?.toDouble() ?? 0.0,
          driver.longitude?.toDouble() ?? 0.0,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        onTap: () {
          context.read<MapCubit>().showDriverDetailsDialog(context, driver);
        },
      );
      _markers[markerId] = marker;
    } else {
      _markers.remove(driver.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var cubit = context.read<MapCubit>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorManager.white,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
      ),
      body: BlocConsumer<MapCubit, MapState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SafeArea(
            child: cubit.currentLatLng == null &&
                    state is GetDriversLoadingState
                ? Container(
                    color: ColorManager.white,
                    child: Center(
                      child: lot.Lottie.asset(JsonAssets.mapLoading),
                    ),
                  )
                : Stack(
                    children: [
                      // Google Map
                      StreamBuilder<List<Data>>(
                        stream: _signalRService.stream,
                        builder: (context, snapshot) {
                        
                          if (snapshot.hasError)
                          
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _updateMarkersBatch(snapshot.data!);
                            });
                          }
                          return GoogleMap(
                            mapType: MapType.normal,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: true,
                            initialCameraPosition: CameraPosition(
                              zoom: 17.0,
                              target: LatLng(
                                cubit.currentLatLng?.latitude ?? 0.0,
                                cubit.currentLatLng?.longitude ?? 0.0,
                              ),
                            ),
                            onMapCreated: _onMapCreated,
                            markers: Set<Marker>.of(_markers.values),
                          );
                        },
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          height: 60.h,
                          width: width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                ColorManager.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: AppBar(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            iconTheme: IconThemeData(
                              color: ColorManager.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
      floatingActionButton: CustomFloatingActionButton(
        takeMeToMyLocation: takeMeToMyLocation,
      ),
    );
  }

  @override
  void dispose() {
    _signalRService.dispose();
    _customInfoWindowController.dispose();
    _mapController?.dispose();
    priceController?.dispose();
    passengersController?.dispose();
    _driverUpdateSubscription.cancel();
    _driverResponseSubscription.cancel();
    super.dispose();
  }

  Future<void> takeMeToMyLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition();
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 16,
          target: LatLng(position.latitude, position.longitude),
        ),
      ));
    } else if (status.isDenied) {
    
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  // Updated fetchInitialData to parse the entire response into GetAllDriversModel and then extract its data list.
  void fetchInitialData() async {
    try {
      final response =
          await DioHelper.getData(endPoint: Constants.getDriversEndPoint);

      if (response?.statusCode == 200 && response?.data != null) {
        // Parse the full JSON response into the model
        final model = GetAllDriversModel.fromJson(response!.data);
        final drivers = model.data ?? [];
        final filteredDrivers = drivers.where((driver) {
         
          return driver.isOnline == true && driver.gender == widget.gender;
        }).toList();
        if (drivers.isNotEmpty) {
          // Filter the drivers based on your conditions
          final filteredDrivers = drivers
              .where((driver) =>
                  driver.isOnline == true && driver.gender == widget.gender)
              .toList();
          if (mounted) {
            _updateMarkersBatch(filteredDrivers);
          }
        } else {
         
        }
      } else {
        
      }
    } catch (error) {
      
    }
  }

  bool isRTL() {
    return context.locale == ARABIC_LOCALE;
  }

  void _showAcceptedDialog(BuildContext context) async {
    await _playNotification();

    if (context.mounted) {
      _showCustomDialog(
        context: context,
        icon: Icons.check_circle_outline,
        iconColor: ColorManager.teal,
        title: AppStrings.accepted.tr(),
        description: AppStrings.acceptedDescription.tr(),
        buttonColor: ColorManager.teal,
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TripInformation(
                driverId: _selectedDriver?.id ?? "",
                driverImageUrl:
                    "${Constants.hubUrl}${_selectedDriver?.personalImagePath ?? ""}",
                firstName: _selectedDriver?.firstName ?? "",
                lastName: _selectedDriver?.lastName ?? "",
                carModel: _selectedDriver?.carModel ?? "",
                carColor: _selectedDriver?.carColor ?? "",
                carPlateNumber: _selectedDriver?.numberPlate ?? "",
                driverLocation: LatLng(
                  _selectedDriver?.latitude?.toDouble() ?? 0.0,
                  _selectedDriver?.longitude?.toDouble() ?? 0.0,
                ),
                onCallPressed: () {},
                onCancelPressed: (value) {},
                riderLocation: LatLng(
                  _selectedDriver?.latitude?.toDouble() ?? 0.0,
                  _selectedDriver?.longitude?.toDouble() ?? 0.0,
                ),
                scrollController: scrollController,
              ),
            ),
          );
        },
      );
    }
  }

  void _showRejectedDialog(BuildContext context) async {
    await _playNotification();
    if (context.mounted) {
      _showCustomDialog(
        context: context,
        icon: Icons.cancel_outlined,
        iconColor: ColorManager.error,
        title: AppStrings.rejected.tr(),
        description: AppStrings.rejectedDescription.tr(),
        buttonColor: ColorManager.error,
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  Future<void> _playNotification() async {
    final audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource('sounds/requestAlert.wav'));
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 500);
    }
  }

  void _showCustomDialog({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required Color buttonColor,
    required void Function()? onPressed,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Icon(
                          icon,
                          color: iconColor,
                          size: 80,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ColorManager.black,
                        ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorManager.black, fontSize: AppSize.s18.sp),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    onPressed: onPressed,
                    child: Text(
                      AppStrings.ok.tr(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: ColorManager.white,
                            fontSize: FontSize.s12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
