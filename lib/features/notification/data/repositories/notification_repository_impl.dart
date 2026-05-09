import 'package:dartz/dartz.dart';
import 'package:meshwark_rider/core/errors/failures.dart';
import 'package:meshwark_rider/features/notification/data/datasources/notification_datasource.dart';
import 'package:meshwark_rider/features/notification/domain/entities/notification_entities.dart';
import 'package:meshwark_rider/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications() async {
    try {
      final notifications = await remoteDataSource.getNotifications();
      return Right(notifications);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await remoteDataSource.markAsRead(notificationId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await remoteDataSource.markAllAsRead();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(
      String notificationId) async {
    try {
      await remoteDataSource.deleteNotification(notificationId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await remoteDataSource.getUnreadCount();
      return Right(count);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationSettings>>
      getNotificationSettings() async {
    try {
      final settings = await remoteDataSource.getNotificationSettings();
      return Right(settings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateNotificationSettings(
      NotificationSettings settings) async {
    try {
      await remoteDataSource.updateNotificationSettings(settings);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
