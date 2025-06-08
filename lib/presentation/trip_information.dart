import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meshwark_rider/presentation/bloc/map_bloc/map_cubit.dart';
import 'package:meshwark_rider/presentation/resources/Strings_manager.dart';
import 'package:meshwark_rider/presentation/resources/color_manager.dart';
import 'dart:async';

import '../data/network/signalR_service.dart';

class TripInformation extends StatefulWidget {
  final String driverId;
  final String driverImageUrl;
  final String firstName;
  final String lastName;
  final String carModel;
  final String carColor;
  final String carPlateNumber;
  final LatLng driverLocation;
  final LatLng riderLocation;
  final Function onCallPressed;
  final Function(String) onCancelPressed;
  final ScrollController scrollController;

  const TripInformation({
    super.key,
    required this.driverId,
    required this.driverImageUrl,
    required this.firstName,
    required this.lastName,
    required this.carModel,
    required this.carColor,
    required this.carPlateNumber,
    required this.driverLocation,
    required this.riderLocation,
    required this.onCallPressed,
    required this.onCancelPressed,
    required this.scrollController,
  });

  @override
  _TripInformationState createState() => _TripInformationState();
}

class _TripInformationState extends State<TripInformation>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _secondsRemaining = 0;
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  late AnimationController _animationController;
  late Animation<double> _animation;
  Uint8List? imageData;
  final List<String> _cancellationReasons = [
    AppStrings.driverIsTakingTooLong.tr(),
    AppStrings.changedMyMind.tr(),
    AppStrings.emergencySituation.tr(),
    AppStrings.incorrectPickupLocation.tr(),
    AppStrings.foundAlternativeTransportation.tr(),
    AppStrings.weatherConditions.tr(),
    AppStrings.other.tr(),
  ];

  bool _showCancellationReasons = false;
  String? _selectedReason;
  SignalRService signalRService = SignalRService();
  Map<String, dynamic> notificationData = {};
  @override
  void initState() {
    super.initState();
    _listenForCancellationNotifications();
     context.read<MapCubit>().initializeNotification();
    _calculateDistanceAndTime();
    _setMarkers();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }
  void _listenForCancellationNotifications() {
    signalRService.cancellationNotificationStream.listen((data) {
      setState(() {
        notificationData = data;
      });

     print(notificationData.toString());

      // Show the notification as a SnackBar after dialog closes
      if (notificationData.isNotEmpty) {
       context.read<MapCubit>().showNotification(id: 5,
           title: AppStrings.cancelTrip.tr(),
           body: "${notificationData['Reason']}");
       Navigator.pop(context);
      }
    });
  }
  @override
  void dispose() {
    _timer?.cancel();
    _mapController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _calculateDistanceAndTime() async {
    try {
      final distance = Geolocator.distanceBetween(
        widget.riderLocation.latitude,
        widget.riderLocation.longitude,
        widget.driverLocation.latitude,
        widget.driverLocation.longitude,
      );

      setState(() {
        _secondsRemaining = (distance / 500 * 60).ceil();
      });

      _startTimer();
    } catch (e) {
      print('Error calculating distance and time: $e');
    }
  }

  void _setMarkers() {
    _markers.add(
      Marker(
        markerId: const MarkerId('rider'),
        position: widget.riderLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: widget.driverLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    imageData = await context
        .read<MapCubit>()
        .getBytesFromAsset('assets/icons/appLogoSplash.png', context);
    _fitBounds();
  }

  void _fitBounds() {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        widget.riderLocation.latitude < widget.driverLocation.latitude
            ? widget.riderLocation.latitude
            : widget.driverLocation.latitude,
        widget.riderLocation.longitude < widget.driverLocation.longitude
            ? widget.riderLocation.longitude
            : widget.driverLocation.longitude,
      ),
      northeast: LatLng(
        widget.riderLocation.latitude > widget.driverLocation.latitude
            ? widget.riderLocation.latitude
            : widget.driverLocation.latitude,
        widget.riderLocation.longitude > widget.driverLocation.longitude
            ? widget.riderLocation.longitude
            : widget.driverLocation.longitude,
      ),
    );

    _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: 0,
      ),
      body: BlocConsumer<MapCubit, MapState>(
        listener: (context, state) {
          if (state is CancelTripSuccessState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
            ),
            child: ListView(
              controller: widget.scrollController,
              padding: EdgeInsets.zero,
              children: [
                _buildMapSection(),
                _buildDriverInfoSection(),
                _buildEstimatedTimeSection(),
                _buildCancelTripSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapSection() {
    return SizedBox(
      height: 250.h,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              (widget.riderLocation.latitude + widget.driverLocation.latitude) /
                  2,
              (widget.riderLocation.longitude +
                      widget.driverLocation.longitude) /
                  2,
            ),
            zoom: 12,
          ),
          markers: _markers,
          myLocationEnabled: true,
          compassEnabled: false,
          zoomControlsEnabled: false,
        ),
      ),
    );
  }

  Widget _buildDriverInfoSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(widget.driverImageUrl),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.firstName} ${widget.lastName}',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${widget.carModel} • ${widget.carColor}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${AppStrings.plateNumber.tr()}: ${widget.carPlateNumber}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.phone, color: ColorManager.teal, size: 28.w),
            onPressed: () => widget.onCallPressed(),
          ),
        ],
      ),
    );
  }

  Widget _buildEstimatedTimeSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.access_time, color: ColorManager.teal, size: 24.w),
          SizedBox(width: 10.w),
          Text(
            _secondsRemaining > 0
                ? '${AppStrings.estimatedTime.tr()}: ${_formatDuration(_secondsRemaining)}'
                : AppStrings.driverIsHere.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelTripSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.cancelTrip.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () {
              setState(() {
                _showCancellationReasons = !_showCancellationReasons;
                if (_showCancellationReasons) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: ColorManager.error,
              ),
              child: Center(
                child: Text(
                  AppStrings.cancelTrip.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _animation,
            child: Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _cancellationReasons.map((reason) {
                    return GestureDetector(
                      onTap: () {
                        widget.onCancelPressed(reason);
                        setState(() {
                          _selectedReason = reason;
                          _showCancellationReasons = false;
                          _animationController.reverse();
                        });
                        context.read<MapCubit>().cancelTrip(
                            driverId: widget.driverId, reason: reason);

                        Navigator.pop(context);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: _selectedReason == reason
                              ? ColorManager.primary
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          reason,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: _selectedReason == reason
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList()),
            ),
          ),
        ],
      ),
    );
  }
}
