import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meshwark_rider/app/constants.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'domain/all_drivers_model.dart'; // Contains GetAllDriversModel and Data

class DriverService {
  final String apiUrl =
      'http://meshwark-001-site1.jtempurl.com/api/Users/drivers'; // Replace with your actual API endpoint

  // Parse the response into our wrapper model and return its inner data list.
  Future<List<Data>> getAllDrivers() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      GetAllDriversModel model = GetAllDriversModel.fromJson(jsonResponse);
      return model.data ?? [];
    } else {
      throw Exception('Failed to load drivers');
    }
  }
}

class DriverApp extends StatefulWidget {
  const DriverApp({super.key});

  @override
  _DriverAppState createState() => _DriverAppState();
}

class _DriverAppState extends State<DriverApp> {
  Set<Marker> _markers = <Marker>{};
  GoogleMapController? _mapController;
  late HubConnection _hubConnection;

  @override
  void initState() {
    super.initState();
    _initializeSignalR();
    _loadInitialDrivers();
  }

  // Load initial drivers from the API and add markers for each driver.
  Future<void> _loadInitialDrivers() async {
    try {
      DriverService driverService = DriverService();
      List<Data> drivers = await driverService.getAllDrivers();

      // Add markers for all drivers in the returned list.
      for (var driver in drivers) {
        final marker = Marker(
          markerId: MarkerId(driver.id ?? ''),
          position: LatLng(
            driver.latitude?.toDouble() ?? 0.0,
            driver.longitude?.toDouble() ?? 0.0,
          ),
          infoWindow: InfoWindow(
            title: '${driver.firstName ?? ''} ${driver.lastName ?? ''}',
            snippet: 'Seats available: ${driver.availableSeats ?? 0}',
          ),
        );

        setState(() {
          _markers.add(marker);
        });
      }
    } catch (e) {
      print('Error loading initial drivers: $e');
    }
  }

  // Initialize SignalR and listen for real-time updates.
  Future<void> _initializeSignalR() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl(
            'http://meshwark-001-site1.jtempurl.com/driverHub') // Replace with your actual hub URL
        .build();

    _hubConnection.on('ReceiveDriverInformationUpdate', (arguments) {
      print('Received real-time update from SignalR');
      if (arguments != null && arguments.isNotEmpty) {
        // Assume that SignalR sends a flat JSON representing a single driver's updated data.
        final userJson = arguments[0] as String;
        print('Driver update JSON: $userJson');

        try {
          final updatedDriver = Data.fromJson(json.decode(userJson));
          _updateDriverMarker(updatedDriver);
        } catch (e) {
          print('Error parsing driver update: $e');
        }
      }
    });

    try {
      await _hubConnection.start();
      print('SignalR connection started');
    } catch (e) {
      print('Error starting SignalR connection: $e');
    }
  }

  // Update marker position for a specific driver.
  void _updateDriverMarker(Data updatedDriver) {
    // Validate latitude and longitude.
    if (updatedDriver.latitude == null || updatedDriver.longitude == null) {
      print('Driver location is invalid');
      return;
    }

    // Remove the old marker if it exists.
    _markers.removeWhere((marker) => marker.markerId.value == (updatedDriver.id ?? ''));

    // Add the updated marker.
    final newMarker = Marker(
      markerId: MarkerId(updatedDriver.id ?? ''),
      position: LatLng(
        updatedDriver.latitude!.toDouble(),
        updatedDriver.longitude!.toDouble(),
      ),
      infoWindow: InfoWindow(
        title: '${updatedDriver.firstName ?? ''} ${updatedDriver.lastName ?? ''}',
        snippet: 'Seats available: ${updatedDriver.availableSeats ?? 0}',
      ),
    );

    setState(() {
      print('Adding marker at: ${updatedDriver.latitude}, ${updatedDriver.longitude}');
      _markers.add(newMarker);
    });

    // Optionally, move the camera to the updated driver’s location.
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(
          updatedDriver.latitude!.toDouble(),
          updatedDriver.longitude!.toDouble(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Locations'),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(30.019944, 31.463922), // Your initial position
          zoom: 13.0,
        ),
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
          print('Google Map initialized');
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _hubConnection.stop();
    super.dispose();
  }
}

class SignalRService {
  late HubConnection hubConnection;

  Future<void> initializeConnection() async {
    hubConnection = HubConnectionBuilder()
        .withUrl(
            'http://meshwark-001-site1.jtempurl.com/driverHub') // Replace with your actual hub URL
        .build();

    try {
      await hubConnection.start();
      print('SignalR connection started');
    } catch (e) {
      print('Error starting SignalR connection: $e');
    }
  }

  void dispose() {
    hubConnection.stop();
  }
}
