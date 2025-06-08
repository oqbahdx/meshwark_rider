import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meshwark_rider/app/constants.dart';
import 'package:meshwark_rider/data/network/dio_helper.dart';
import 'package:meshwark_rider/domain/all_drivers_model.dart'; // Contains GetAllDriversModel & Data
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:ui' as ui;
import '../../../domain/models.dart';
import '../../map/widgets/map_widgets.dart';
import '../../resources/Strings_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? currentLatLng;
  AllDrivers? allDrivers;
  late Uint8List myIcon;
  final Map<String, Marker> driversMarkers = {};
  Map<PolylineId, Polyline> polyLines = {};
  List<LatLng> polylineCoordinates = [];
  final _localNotificationService = FlutterLocalNotificationsPlugin();

  // Use Data as the type for individual driver objects.
  List<Data>? getAllDriversList;
  List<Marker> markers = <Marker>[];
  List<dynamic> data = []; // Temporary holder for raw JSON data

  Future<void> initializeNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/launcher_icon");
    DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );
    await _localNotificationService.initialize(settings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  NotificationDetails _notificationDetails() {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channel_id", "channel_name",
            channelDescription: "channelDescription",
            importance: Importance.max,
            priority: Priority.max,
            playSound: true);
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();

    return const NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final notificationDetails = _notificationDetails();
    await _localNotificationService.show(id, title, body, notificationDetails);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    if (kDebugMode) {
      print("id : $id");
    }
  }

  void onDidReceiveNotificationResponse(NotificationResponse details) {
    if (kDebugMode) {
      print("$details");
    }
  }

  Future<void> cancelTrip({required String driverId, required String reason}) async {
    emit(CancelTripLoadingState());
    DioHelper.postData(endPoint: Constants.cancelRequestToDriverEndPoint, data: {
      "riderId": Constants.id,
      "driverId": driverId,
      "reason": reason,
      "cancellingParty": "Rider"
    }).then((value) {
      debugPrint(value.toString());
      emit(CancelTripSuccessState());
    }).catchError((err) {
      debugPrint(err.toString());
      emit(CancelTripErrorState(err.toString()));
    });
  }

  // Updated: Now the driver is of type Data.
  void showDriverDetailsDialog(BuildContext context, Data driver) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile Section
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      "${Constants.hubUrl}/${driver.personalImagePath}"),
                ),
                const SizedBox(height: 15),
                Text(
                  "${driver.firstName ?? ''} ${driver.lastName ?? ''}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      "${driver.rating ?? 4.8}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Destination Information
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "${AppStrings.nextDestination.tr()}: ${driver.nextDestination ?? ''}",
                          style:
                              TextStyle(fontSize: 16, color: Colors.blue[800]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Seats Information
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSeatInfo(Icons.event_seat, Colors.green,
                        "${AppStrings.seatsAvailable.tr()}: ${driver.availableSeats ?? 0}"),
                    _buildSeatInfo(Icons.event_seat, Colors.red,
                        "${AppStrings.reservedSeats.tr()}: ${driver.reservedSeats ?? 0}"),
                  ],
                ),
                const SizedBox(height: 30),
                // Actions: Cancel and Book buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: ColorManager.white,
                          backgroundColor: ColorManager.error,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(AppStrings.cancel.tr()),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          showBookingDetailsDialog(context, driver.id ?? "");
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: ColorManager.white,
                          backgroundColor: ColorManager.primary,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(AppStrings.book.tr()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSeatInfo(IconData icon, Color color, String text) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(fontSize: 14.sp),
        ),
      ],
    );
  }

  void showBookingDetailsDialog(BuildContext context, String driverId) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController passengerController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.pleaseEnterPriceAndPanssengers.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    style: getSemiBoldStyle(
                        color: ColorManager.primary, fontSize: FontSize.s18.sp),
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: AppStrings.price.tr(),
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.thisFieldIsRequired.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    style: getSemiBoldStyle(
                        color: ColorManager.primary, fontSize: FontSize.s18.sp),
                    controller: passengerController,
                    decoration: InputDecoration(
                      labelText: AppStrings.numberOfPassergers.tr(),
                      prefixIcon: const Icon(Icons.people),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.thisFieldIsRequired.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: ColorManager.error,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(AppStrings.cancel.tr()),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final price =
                                  priceController.text;
                              final passengers =
                                  passengerController.text;
                              sendRequestToDriver(
                                  price: double.tryParse(price) ?? 0.0,
                                  passengers:
                                      int.tryParse(passengers) ?? 0,
                                  driverId: driverId,
                                  phoneNumber: Constants.phoneNumber,
                                  latitude: currentLatLng?.latitude ?? 0.0,
                                  longitude: currentLatLng?.longitude ?? 0.0);
                              Navigator.of(context).pop();
                              print('Booking confirmed: $price, $passengers');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: ColorManager.primary,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(AppStrings.book.tr()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polyLines[id] = polyline;
    // setState(() {});
  }

  Future<Uint8List?> getBytesFromAsset(
      String path, BuildContext context) async {
    try {
      double pixelRatio = MediaQuery.of(context).devicePixelRatio;
      ByteData data = await rootBundle.load(path);

      // Adjust the size of the icon based on device pixel ratio
      ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: (15 * pixelRatio).round(),
      );

      ui.FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
          ?.buffer
          .asUint8List();
    } catch (e) {
      print("Error loading marker icon: $e");
      return null;
    }
  }

  Future<void> takeMeToMyLocation() async {
    if (await Permission.location.request().isGranted) {
      Position position = await Geolocator.getCurrentPosition();
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            zoom: 11,
            target: LatLng(position.latitude, position.longitude)),
      ));
    } else {
      await Permission.location.request();
    }
  }

  final _markersSubject = BehaviorSubject<List<Marker>>.seeded([]); // Starts with an empty list

  Stream<List<Marker>> get markersStream => _markersSubject.stream;

  Future<void> getAllDrivers() async {
    markers.clear();
    emit(GetDriversLoadingState());
    try {
      var response =
          await DioHelper.getData(endPoint: Constants.getDriversEndPoint);

      if (response != null && response.statusCode == 200) {
        // Parse the JSON response wrapper into our model
        GetAllDriversModel model = GetAllDriversModel.fromJson(response.data);
        getAllDriversList = model.data; // extract the list of Data

        // Create markers for all drivers
        if(getAllDriversList != null){
          for (var driver in getAllDriversList!) {
            if (driver.latitude != null &&
                driver.longitude != null &&
                driver.isOnline != null) {
              markers.add(
                Marker(
                  markerId: MarkerId(driver.id ?? ""),
                  position: LatLng(
                      driver.latitude?.toDouble() ?? 0.0,
                      driver.longitude?.toDouble() ?? 0.0),
                  infoWindow: InfoWindow(
                    title: 'Driver ${driver.firstName}',
                  ),
                ),
              );
            }
          }
        }

        // Push the new markers list to the stream
        _markersSubject.add(markers);
        emit(GetDriversSuccessState());
      } else {
        emit(GetDriversErrorState('Failed to load drivers'));
      }
    } catch (error) {
      emit(GetDriversErrorState(error.toString()));
    }
  }

  // Update driver marker using Data type
  void updateDriverMarker(Data updatedDriver) {
    int index = getAllDriversList!
        .indexWhere((driver) => driver.id == updatedDriver.id);
    if (index != -1) {
      // Update the driver in our list
      getAllDriversList![index] = updatedDriver;

      // Update the corresponding marker
      markers[index] = Marker(
        markerId: MarkerId(updatedDriver.id ?? ""),
        position: LatLng(
          updatedDriver.latitude?.toDouble() ?? 0.0,
          updatedDriver.longitude?.toDouble() ?? 0.0,
        ),
        infoWindow: InfoWindow(
            title: 'Driver ${updatedDriver.firstName}'),
      );

      // Push the updated markers list to the stream
      _markersSubject.add(markers);
    }
  }

  void sendPushNotification(
      {required String fcmToken, required String title, required String body}) {
    DioHelper.postData(endPoint: Constants.sendPushNotificationEndPoint, data: {
      "fcmToken": fcmToken,
      "title": title,
      "body": body,
    }).then((value) {}).catchError((error) {
      print(error.toString());
    });
  }

  // Update sendRequestToDriver to use provided parameters
  sendRequestToDriver({
    required double price,
    required int passengers,
    required String driverId,
    required double latitude,
    required double longitude,
    required String phoneNumber,
  }) {
    DioHelper.postData(
        endPoint:
            "${Constants.baseUrl}${Constants.sendRequestToDriverEndPoint}",
        data: {
          "riderId": Constants.id,
          "driverId": driverId,
          "firstName": Constants.firstName,
          "lastName": Constants.lastName,
          "price": price,
          "passengers": passengers,
          "latitude": latitude,
          "longitude": longitude,
        }).then((value) {
      print(value.toString());
    }).catchError((e) {
      print(e.toString());
    });
  }

  getAlertDialog({
    required String firstName,
    required String nextDestination,
    required String carModel,
    required String carColor,
    required String plateNumber,
    required String availableSeats,
    required String reservedSeats,
    required void Function()? onConfirm,
    required BuildContext context,
  }) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return showGeneralDialog(
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, anim1, anim2) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s10)),
        backgroundColor: Colors.white70,
        elevation: 2,
        actions: [
          SizedBox(height: height * 0.02),
          BuildInfoWindowRow(
              keyText: AppStrings.name.tr(), valueText: firstName),
          SizedBox(height: height * 0.015),
          BuildInfoWindowRow(
              keyText: AppStrings.nextDestination.tr(),
              valueText: nextDestination),
          SizedBox(height: height * 0.015),
          BuildInfoWindowRow(
              keyText: AppStrings.carModel.tr(), valueText: carModel),
          SizedBox(height: height * 0.015),
          BuildInfoWindowRow(
              keyText: AppStrings.carColor.tr(), valueText: carColor),
          SizedBox(height: height * 0.015),
          BuildInfoWindowRow(
              keyText: AppStrings.plateNumber.tr(), valueText: plateNumber),
          SizedBox(height: height * 0.015),
          BuildInfoWindowRow(
              keyText: AppStrings.seatsAvailable.tr(),
              valueText: availableSeats),
          SizedBox(height: height * 0.015),
          BuildInfoWindowRow(
              keyText: AppStrings.reservedSeats.tr(), valueText: reservedSeats),
          SizedBox(height: height * 0.015),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(AppStrings.book.tr(),
                      style: getSemiBoldStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s14.sp)),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  foregroundColor: ColorManager.primary,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: ColorManager.error),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 24),
                ),
                child: Text(AppStrings.cancel.tr(),
                    style: getSemiBoldStyle(
                        color: ColorManager.error, fontSize: FontSize.s14.sp)),
              ),
            ],
          ),
        ],
      ),
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
        child: FadeTransition(
          opacity: anim1,
          child: child,
        ),
      ),
      context: context,
    );
  }
}

void sendPriceAlertDialog({
  required void Function()? onPressed,
  required TextEditingController? priceController,
  required TextEditingController? passengerController,
  required BuildContext context,
}) {
  showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (ctx, anim1, anim2) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: ContentBox(
        priceController: priceController!,
        passengerController: passengerController!,
        onPressed: onPressed!,
        context: context,
      ),
    ),
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
      filter:
          ImageFilter.blur(sigmaX: 5 * anim1.value, sigmaY: 5 * anim1.value),
      child: ScaleTransition(
        scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
        child: FadeTransition(
          opacity: anim1,
          child: child,
        ),
      ),
    ),
    context: context,
  );
}

class ContentBox extends StatelessWidget {
  final TextEditingController priceController;
  final TextEditingController passengerController;
  final VoidCallback onPressed;
  final BuildContext context;

  const ContentBox({
    super.key,
    required this.priceController,
    required this.passengerController,
    required this.onPressed,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.pleaseEnterPriceAndPanssengers.tr(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorManager.primary,
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: priceController,
            label: AppStrings.price.tr(),
            icon: Icons.attach_money,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: passengerController,
            label: AppStrings.numberOfPassergers.tr(),
            icon: Icons.people,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(AppStrings.book.tr(),
                      style: getSemiBoldStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s14.sp)),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  foregroundColor: ColorManager.primary,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: ColorManager.error),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 24),
                ),
                child: Text(AppStrings.cancel.tr(),
                    style: getSemiBoldStyle(
                        color: ColorManager.error, fontSize: FontSize.s14.sp)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 22.sp),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: ColorManager.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: ColorManager.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: ColorManager.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}

Widget _buildTextField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(30),
    ),
    child: TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp),
        floatingLabelStyle: TextStyle(color: Colors.grey, fontSize: 16.sp),
        prefixIcon: Icon(icon, color: ColorManager.primary),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    ),
  );
}

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback takeMeToMyLocation;

  const CustomFloatingActionButton(
      {required this.takeMeToMyLocation, super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: takeMeToMyLocation,
      backgroundColor: Colors.white,
      tooltip: 'Take me to my location',
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
          gradient: LinearGradient(
            colors: [
              ColorManager.primary,
              ColorManager.primary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(
          Icons.my_location,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
