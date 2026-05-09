class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type;
  final DateTime createdAt;
  final bool isRead;
  final String? data;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    required this.isRead,
    this.data,
  });
}

class NotificationSettings {
  final bool pushEnabled;
  final bool tripUpdates;
  final bool promotions;
  final bool accountUpdates;

  const NotificationSettings({
    required this.pushEnabled,
    required this.tripUpdates,
    required this.promotions,
    required this.accountUpdates,
  });
}
