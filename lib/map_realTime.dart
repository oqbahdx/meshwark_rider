import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:signalr_netcore/signalr_client.dart' as signalr;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:meshwark_rider/app/constants.dart';
import 'package:meshwark_rider/domain/all_drivers_model.dart'; // Contains GetAllDriversModel & Data

class DriverTracker extends StatefulWidget {
  const DriverTracker({Key? key}) : super(key: key);

  @override
  _DriverTrackerState createState() => _DriverTrackerState();
}

class _DriverTrackerState extends State<DriverTracker> {
  // Instead of storing GetAllDriversModel objects, we now store individual driver records of type Data.
  final List<Data> _drivers = [];
  final Set<Marker> _markers = {};
  late GoogleMapController _mapController;
  final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  late signalr.HubConnection _hubConnection;

  @override
  void initState() {
    super.initState();
    _fetchDrivers();
    _initSignalR();
  }

  Future<void> _fetchDrivers() async {
    final response = await http.get(Uri.parse(Constants.getDriversEndPoint));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // Parse the wrapper response into our model and get its inner data list.
      final GetAllDriversModel model = GetAllDriversModel.fromJson(jsonResponse);
      setState(() {
        _drivers.clear();
        if (model.data != null) {
          _drivers.addAll(model.data!);
        }
        _updateMarkers();
      });
    } else {
      throw Exception('Failed to load drivers');
    }
  }

  void _initSignalR() async {
    _hubConnection = signalr.HubConnectionBuilder()
        .withUrl('${Constants.hubUrl}driverHub') // Replace with your actual hub URL
        .build();

    _hubConnection.on('ReceiveDriverInformationUpdate', _handleDriverUpdated);
    await _hubConnection.start();
  }

  void _handleDriverUpdated(List<dynamic>? args) {
    if (args != null && args.isNotEmpty) {
      // Assume that SignalR sends a JSON object representing a single driver update.
      final Map<String, dynamic> updatedJson = args[0] as Map<String, dynamic>;
      final Data updatedDriver = Data.fromJson(updatedJson);
      setState(() {
        final int index = _drivers.indexWhere((driver) => driver.id == updatedDriver.id);
        if (index != -1) {
          _drivers[index] = updatedDriver;
        } else {
          _drivers.add(updatedDriver);
        }
        _updateMarkers();
      });
    }
  }

  void _updateMarkers() {
    setState(() {
      _markers.clear();
      for (final driver in _drivers) {
        if (driver.isOnline == true &&
            driver.latitude != null &&
            driver.longitude != null) {
          _markers.add(
            Marker(
              markerId: MarkerId(driver.id ?? ''),
              position: LatLng(
                driver.latitude!.toDouble(),
                driver.longitude!.toDouble(),
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              onTap: () {
                _customInfoWindowController.addInfoWindow!(
                  _buildInfoWindowContent(driver),
                  LatLng(
                    driver.latitude!.toDouble(),
                    driver.longitude!.toDouble(),
                  ),
                );
              },
            ),
          );
        }
      }
    });
  }

  Widget _buildInfoWindowContent(Data driver) {
    return Container(
      width: 200,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${driver.firstName ?? ''} ${driver.lastName ?? ''}'),
          Text('Phone: ${driver.phoneNumber ?? ''}'),
          Text('Car: ${driver.carModel ?? ''} (${driver.carColor ?? ''})'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Tracker')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(30.0153703, 31.1795737), // Your initial position
              zoom: 12,
            ),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _customInfoWindowController.googleMapController = controller;
            },
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 100,
            width: 200,
            offset: 50,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    _hubConnection.stop();
    super.dispose();
  }
}
