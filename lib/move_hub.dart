import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meshwark_rider/app/constants.dart';
import 'package:meshwark_rider/data/network/dio_helper.dart';
import 'package:meshwark_rider/domain/all_drivers_model.dart'; // Contains GetAllDriversModel and Data
import 'package:signalr_netcore/signalr_client.dart' as signalr;

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late signalr.HubConnection _hubConnection;
  
  // Instead of storing full wrappers, we now hold the inner driver records.
  final StreamController<List<Data>> _streamController =
      StreamController.broadcast();
  List<Data> _users = [];
  final Set<Marker> _markers = {};
  late GoogleMapController _mapController;
  final LatLng _initialPosition =
      const LatLng(31.0131996, 31.1800887); // Default position

  @override
  void initState() {
    super.initState();
    _initSignalR();
    _fetchInitialData();
  }

  // Fetch the full API response, parse into GetAllDriversModel, and then extract the inner data list.
  void _fetchInitialData() async {
    try {
      final response =
          await DioHelper.getData(endPoint: Constants.getDriversEndPoint);
      if (response != null && response.statusCode == 200) {
        final GetAllDriversModel model = GetAllDriversModel.fromJson(response.data);
        setState(() {
          _users = model.data ?? [];
          _streamController.add(_users);
          _updateMarkers();
        });
      }
    } catch (error) {
      _streamController.addError('Failed to fetch initial data');
    }
  }

  // Initialize SignalR and listen for real-time driver updates.
  void _initSignalR() async {
    _hubConnection = signalr.HubConnectionBuilder()
        .withUrl('${Constants.hubUrl}driverHub')
        .build();

    _hubConnection.on('ReceiveDriverInformationUpdate', _handleDriverUpdated);
    await _hubConnection.start();
  }

  // Parse the update into a Data object and update the list.
  void _handleDriverUpdated(List<dynamic>? args) {
    if (args != null && args.isNotEmpty) {
      final Data updatedDriver =
          Data.fromJson(args?[0] as Map<String, dynamic>);
      setState(() {
        final int index = _users.indexWhere((u) => u.id == updatedDriver.id);
        if (index != -1) {
          _users[index] = updatedDriver;
        } else {
          _users.add(updatedDriver);
        }
        _streamController.add(_users);
        _updateMarkers();
      });
      print("driver id: ${updatedDriver.id}");
    }
  }

  // Rebuild markers from the current list of drivers.
  void _updateMarkers() {
    setState(() {
      _markers.clear();
      for (final user in _users) {
        if (user.latitude != null && user.longitude != null) {
          _markers.add(
            Marker(
              markerId: MarkerId(user.id ?? ''),
              position: LatLng(user.latitude!.toDouble(), user.longitude!.toDouble()),
              infoWindow: InfoWindow(
                title: 'Driver ID: ${user.id}',
                snippet:
                    'Online: ${user.isOnline}\nAvailable Seats: ${user.availableSeats}\nReserved Seats: ${user.reservedSeats}',
              ),
              onTap: () {
                _showDriverDetails(user);
              },
            ),
          );
        }
      }
    });
  }

  // Display a dialog with driver details.
  void _showDriverDetails(Data driver) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Driver Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Name: ${driver.firstName ?? ''} ${driver.lastName ?? ''}"),
              Text("Car Color: ${driver.carColor ?? ''}"),
              Text("Next Destination: ${driver.nextDestination ?? ''}"),
              Text("Car Model: ${driver.carModel ?? ''}"),
              Text("Plate Number: ${driver.numberPlate ?? ''}"),
              Text("Available Seats: ${driver.availableSeats ?? 0}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _hubConnection.stop();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: StreamBuilder<List<Data>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No drivers available'));
          } else {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 10,
              ),
              markers: _markers,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            );
          }
        },
      ),
    );
  }
}
