import 'package:dartz/dartz.dart';
import 'package:meshwark_rider/core/errors/failures.dart';
import 'package:meshwark_rider/features/settings/domain/entities/settings_entities.dart';

abstract class SettingsRepository {
  Future<Either<Failure, AppSettings>> getSettings();
  Future<Either<Failure, void>> updateSettings(AppSettings settings);
  Future<Either<Failure, void>> setLanguage(String languageCode);
  Future<Either<Failure, void>> setDarkMode(bool enabled);
  Future<Either<Failure, void>> clearCache();
  Future<Either<Failure, String>> getAppVersion();
}
