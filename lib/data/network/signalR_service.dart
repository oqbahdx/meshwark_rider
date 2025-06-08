import 'dart:async';
import 'dart:convert';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import '../../app/constants.dart';
import '../../domain/all_drivers_model.dart'; // Contains GetAllDriversModel & Data

class SignalRService {
  late HubConnection hubConnection;

  // Updated: Now the stream holds a list of Data objects.
  final StreamController<List<Data>> _streamController =
      StreamController<List<Data>>.broadcast();
  final StreamController<bool> _driverResponseController =
      StreamController<bool>.broadcast();
  final connectionStatusController = StreamController<String>.broadcast();
  final cancellationNotificationController =
      StreamController<Map<String, dynamic>>.broadcast();
  final Logger logger = Logger('SignalRService');

  // Updated: The internal list now holds Data.
  List<Data> _allDrivers = [];

  Stream<List<Data>> get stream => _streamController.stream;
  Stream<bool> get driverResponseStream => _driverResponseController.stream;
  Stream<Map<String, dynamic>> get cancellationNotificationStream =>
      cancellationNotificationController.stream;

  Future<void> initSignalR() async {
    hubConnection = HubConnectionBuilder()
        .withUrl('${Constants.hubUrl}driverHub')
        .build();

    hubConnection.on("BroadcastDriverUpdate", _handleDriverUpdate);
    hubConnection.on("ReceiveDriverResponse", _handleDriverResponse);
    hubConnection.on('ReceiveCancellationNotification', _handleCancellationNotification);

    try {
      await hubConnection.start();
      logger.info('SignalR connection started');

      if (Constants.id.isNotEmpty) {
        await hubConnection.invoke("IdentifyRider", args: [Constants.id]);
        logger.info('Rider identified successfully');
      } else {
        logger.warning('Invalid rider ID');
      }

      // Fetch initial driver data
      await fetchAllDrivers();
    } catch (e) {
      logger.severe('Error starting SignalR connection: $e');
    }
  }

  void _handleCancellationNotification(List<dynamic>? args) {
    logger.info("Cancellation notification received: $args");
    if (args != null && args.isNotEmpty) {
      Map<String, dynamic> data;
      if (args[0] is String) {
        data = json.decode(args[0] as String);
      } else if (args[0] is Map<String, dynamic>) {
        data = args[0] as Map<String, dynamic>;
      } else {
        logger.warning("Received invalid cancellation notification data: $args");
        return;
      }

      logger.info("Processed cancellation notification: $data");
      cancellationNotificationController.add(data);
    } else {
      logger.warning("Received invalid cancellation notification data: $args");
    }
  }

  Future<void> fetchAllDrivers() async {
    try {
      final response = await http.get(
          Uri.parse('${Constants.baseUrl}${Constants.getDriversEndPoint}'));
      if (response.statusCode == 200) {
        // Parse the response wrapper
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final GetAllDriversModel model = GetAllDriversModel.fromJson(jsonResponse);

        // Extract inner data list (or empty list if null)
        _allDrivers = model.data ?? [];
        _streamController.add(_allDrivers);
      } else {
        logger.warning('Failed to fetch drivers: ${response.statusCode}');
      }
    } catch (e) {
      logger.severe('Error fetching drivers: $e');
    }
  }

void _handleDriverUpdate(List<Object?>? parameters) {
  if (parameters == null) return;
  final updatedDriverJson = parameters[0] as String;
  print('Received JSON: $updatedDriverJson');
  try {
    final updatedDriver = Data.fromJson(json.decode(updatedDriverJson));
    print('Parsed driver: id=${updatedDriver.id}, gender=${updatedDriver.gender}');
    _allDrivers = _allDrivers.where((d) => d.id != updatedDriver.id).toList();
    _allDrivers.add(updatedDriver);
    _streamController.add(List<Data>.from(_allDrivers));
  } catch (e) {
    print('Error parsing driver JSON: $e');
  }
}

  void _handleDriverResponse(List<Object?>? parameters) {
    if (parameters != null && parameters.isNotEmpty) {
      try {
        final accepted = parameters[0] as bool;
        logger.info('Received driver response: $accepted');
        _driverResponseController.add(accepted);
      } catch (e) {
        logger.severe('Error processing driver response: $e');
      }
    } else {
      logger.warning('Received empty or null parameters in _handleDriverResponse');
    }
  }

  Future<void> sendRideRequest(String riderId, String driverId, Map<String, dynamic> request) async {
    try {
      await hubConnection.invoke("SendRideRequest", args: [riderId, driverId, request]);
      logger.info('Ride request sent successfully');
    } catch (e) {
      logger.severe('Error sending ride request: $e');
      throw e;
    }
  }

  Future<void> notifyCancellation(String userId, String reason, bool isDriver) async {
    try {
      await hubConnection.invoke("NotifyCancellation", args: [userId, reason, isDriver]);
      logger.info('Cancellation notification sent successfully');
    } catch (e) {
      logger.severe('Error sending cancellation notification: $e');
      throw e;
    }
  }

  Future<void> sendCancellationNotification(bool isDriver, String reason) async {
    try {
      await hubConnection.invoke("SendCancellationNotification", args: [isDriver, reason]);
      logger.info('Cancellation notification sent successfully');
    } catch (e) {
      logger.severe('Error sending cancellation notification: $e');
      throw e;
    }
  }

  Future<void> dispose() async {
    await hubConnection.stop();
    await _streamController.close();
    await _driverResponseController.close();
    await cancellationNotificationController.close();
  }
}
