import 'package:meshwark_rider/core/constants/constants.dart';
import 'package:meshwark_rider/core/network/api_client.dart';
import 'package:meshwark_rider/features/notification/data/models/notification_models.dart';
import 'package:meshwark_rider/features/notification/domain/entities/notification_entities.dart';

abstract class NotificationRemoteDataSource {
  Future<List<AppNotificationModel>> getNotifications();
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String notificationId);
  Future<int> getUnreadCount();
  Future<NotificationSettingsModel> getNotificationSettings();
  Future<void> updateNotificationSettings(NotificationSettings settings);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<AppNotificationModel>> getNotifications() async {
    final result = await apiClient.get(ApiConstants.notificationEndPoint);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) => (response.data['data'] as List)
          .map((n) => AppNotificationModel.fromJson(n))
          .toList(),
    );
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await apiClient
        .put('${ApiConstants.notificationEndPoint}/$notificationId/read');
  }

  @override
  Future<void> markAllAsRead() async {
    await apiClient.put('${ApiConstants.notificationEndPoint}/read-all');
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await apiClient
        .delete('${ApiConstants.notificationEndPoint}/$notificationId');
  }

  @override
  Future<int> getUnreadCount() async {
    final result =
        await apiClient.get('${ApiConstants.notificationEndPoint}/unread');
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) => response.data['count'] ?? 0,
    );
  }

  @override
  Future<NotificationSettingsModel> getNotificationSettings() async {
    final result =
        await apiClient.get('${ApiConstants.notificationEndPoint}/settings');
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) => NotificationSettingsModel.fromJson(response.data['data']),
    );
  }

  @override
  Future<void> updateNotificationSettings(NotificationSettings settings) async {
    await apiClient.put(
      '${ApiConstants.notificationEndPoint}/settings',
      data: (settings as NotificationSettingsModel).toJson(),
    );
  }
}
