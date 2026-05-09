import 'package:dartz/dartz.dart';
import 'package:meshwark_rider/core/errors/failures.dart';
import 'package:meshwark_rider/features/notification/domain/entities/notification_entities.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<AppNotification>>> getNotifications();
  Future<Either<Failure, void>> markAsRead(String notificationId);
  Future<Either<Failure, void>> markAllAsRead();
  Future<Either<Failure, void>> deleteNotification(String notificationId);
  Future<Either<Failure, int>> getUnreadCount();
  Future<Either<Failure, NotificationSettings>> getNotificationSettings();
  Future<Either<Failure, void>> updateNotificationSettings(
      NotificationSettings settings);
}
