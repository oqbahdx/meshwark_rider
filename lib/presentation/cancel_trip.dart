import 'package:flutter/material.dart';
import '../data/network/signalR_service.dart';

class CancellationNotificationPage extends StatefulWidget {
  const CancellationNotificationPage({super.key});

  @override
  _CancellationNotificationPageState createState() => _CancellationNotificationPageState();
}

class _CancellationNotificationPageState extends State<CancellationNotificationPage> {
  final SignalRService signalRService = SignalRService();
  Map<String, dynamic> notificationData = {};

  @override
  void initState() {
    super.initState();
    signalRService.initSignalR();
    _listenForCancellationNotifications();
  }

  void _listenForCancellationNotifications() {
    signalRService.cancellationNotificationStream.listen((data) {
      setState(() {
        notificationData = data;
      });

      // If the notification is received and it's not empty, close the dialog if open
      if (notificationData.isNotEmpty && Navigator.canPop(context)) {
        Navigator.pop(context); // Close the dialog
      }

      // Show the notification as a SnackBar after dialog closes
      if (notificationData.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(notificationData['CancellingParty'] == "Driver"
                ? "Driver cancelled the trip. Reason: ${notificationData['Reason']}"
                : "Rider cancelled the trip. Reason: ${notificationData['Reason']}"),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    signalRService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancellation Notification Test for rider app'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notificationData.isEmpty)
              AlertDialog(
                title: const Text('No Cancellation Notification'),
                content: const Text('No cancellation notification received.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context), // Dismiss dialog manually
                    child: const Text('Close'),
                  ),
                ],
              )
            else ...[
              const Text(
                "Cancellation Details:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildDetailRow("Rider ID:", notificationData['RiderId'] ?? ''),
              _buildDetailRow("Driver ID:", notificationData['DriverId'] ?? ''),
              _buildDetailRow("Reason:", notificationData['Reason'] ?? ''),
              _buildDetailRow("Cancelling Party:", notificationData['CancellingParty'] ?? ''),
              const SizedBox(height: 16),
              Text(
                notificationData['CancellingParty'] == "Driver"
                    ? "Driver cancelled the trip."
                    : "Rider cancelled the trip.",
                style: const TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
