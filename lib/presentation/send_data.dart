import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'dart:async';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final signalRService = SignalRService();
  await signalRService.initializeConnection();

  runApp(MyApp(signalRService: signalRService));
}

class MyApp extends StatelessWidget {
  final SignalRService signalRService;

  const MyApp({Key? key, required this.signalRService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driver Tracking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapScreen(signalRService: signalRService),
    );
  }
}

class SignalRService {
  late HubConnection hubConnection;
  Function(Map<String, dynamic>)? onDriverUpdate;

  Future<void> initializeConnection() async {
    hubConnection = HubConnectionBuilder()
        .withUrl('https://10.0.2.2:5001/driverHub')
        .build();

    hubConnection.on('ReceiveDriverInformationUpdate', _handleDriverUpdate);

    try {
      await hubConnection.start();
      print('SignalR connection started');
    } catch (e) {
      print('Error starting SignalR connection: $e');
    }
  }

  void _handleDriverUpdate(List<Object?>? parameters) {
    if (parameters != null && parameters.isNotEmpty) {
      final driverInfo = json.decode(parameters[0] as String);
      onDriverUpdate?.call(driverInfo);
    }
  }

  void dispose() {
    hubConnection.stop();
  }
}

class Driver {
  final String id;
  final double latitude;
  final double longitude;

  Driver({required this.id, required this.latitude, required this.longitude});
}

class MapScreen extends StatefulWidget {
  final SignalRService signalRService;

  MapScreen({Key? key, required this.signalRService}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Map<String, Driver> _drivers = {};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    widget.signalRService.onDriverUpdate = _handleDriverUpdate;
  }

  void _handleDriverUpdate(Map<String, dynamic> driverInfo) {
    setState(() {
      final driver = Driver(
        id: driverInfo['id'],
        latitude: driverInfo['latitude'],
        longitude: driverInfo['longitude'],
      );
      _drivers[driver.id] = driver;
    });
  }

  @override
  Widget build(BuildContext context) {
    final markers = _drivers.values.map((driver) =>
        Marker(
          markerId: MarkerId(driver.id),
          position: LatLng(driver.latitude, driver.longitude),
          infoWindow: InfoWindow(title: 'Driver ${driver.id}'),
        )
    ).toSet();

    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Tracking'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers,
      ),
    );
  }

  @override
  void dispose() {
    widget.signalRService.onDriverUpdate = null;
    super.dispose();
  }
}