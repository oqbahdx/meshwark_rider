import 'package:flutter/material.dart';
import 'package:meshwark_rider/app/constants.dart';
import 'package:signalr_netcore/signalr_client.dart';

class DriverResponseApp extends StatefulWidget {
  const DriverResponseApp({Key? key}) : super(key: key);

  @override
  _DriverResponseAppState createState() => _DriverResponseAppState();
}

class _DriverResponseAppState extends State<DriverResponseApp> {
  late HubConnection _hubConnection;
  bool _isConnected = false;
  final String _riderId = 'e8706a50-4d75-41c5-ad72-3a82bbf2af88';
  String _responseMessage = '';
  String _debugMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeSignalR();
  }

  void _initializeSignalR() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl("${Constants.hubUrl}driverHub")
        .withAutomaticReconnect()
        .build();

    _hubConnection.onreconnecting(({error}) {
      print("Reconnecting: ${error.toString()}");
      _updateDebugMessage("Reconnecting: ${error.toString()}");
    });

    _hubConnection.onreconnected(({connectionId}) {
      print("Reconnected: $connectionId");
      _updateDebugMessage("Reconnected: $connectionId");
    });

    _hubConnection.on("ReceiveDriverResponse", (List<dynamic>? response) {
      print("Raw response received: $response");
      _updateDebugMessage("Raw response received: $response");

      if (response != null && response.isNotEmpty) {
        bool accepted = response[0] as bool;
        print("Driver response received: $accepted");
        _updateDebugMessage("Driver response received: $accepted");

        setState(() {
          _responseMessage = accepted
              ? "Driver has accepted your request!"
              : "Driver has declined your request.";
        });
      } else {
        print("Invalid response received");
        _updateDebugMessage("Invalid response received");
      }
    });

    try {
      await _hubConnection.start();
      print("SignalR connected successfully");
      _updateDebugMessage("SignalR connected successfully");

      await _hubConnection.invoke("IdentifyRider", args: [_riderId]);
      print("Rider identified successfully");
      _updateDebugMessage("Rider identified successfully");

      setState(() {
        _isConnected = true;
      });
    } catch (e) {
      print("Error starting SignalR connection or identifying rider: $e");
      _updateDebugMessage("Error: $e");
    }
  }

  void _updateDebugMessage(String message) {
    setState(() {
      _debugMessage += "$message\n";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Driver Response App"),
        ),
        body: Center(
          child: _isConnected
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Waiting for Driver Response..."),
              const SizedBox(height: 20),
              Text(_responseMessage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text("Debug Messages:", style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_debugMessage),
                ),
              ),
            ],
          )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hubConnection.stop();
    super.dispose();
  }
}