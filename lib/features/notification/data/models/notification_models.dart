import 'package:meshwark_rider/features/notification/domain/entities/notification_entities.dart';

class AppNotificationModel extends AppNotification {
  const AppNotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
    required super.createdAt,
    required super.isRead,
    super.data,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      isRead: json['isRead'] ?? false,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type,
        'createdAt': createdAt.toIso8601String(),
        'isRead': isRead,
        'data': data,
      };
}

class NotificationSettingsModel extends NotificationSettings {
  const NotificationSettingsModel({
    required super.pushEnabled,
    required super.tripUpdates,
    required super.promotions,
    required super.accountUpdates,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      pushEnabled: json['pushEnabled'] ?? true,
      tripUpdates: json['tripUpdates'] ?? true,
      promotions: json['promotions'] ?? true,
      accountUpdates: json['accountUpdates'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'pushEnabled': pushEnabled,
        'tripUpdates': tripUpdates,
        'promotions': promotions,
        'accountUpdates': accountUpdates,
      };
}
