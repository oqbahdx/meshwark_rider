import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meshwark_rider/app/app_pref.dart';
import 'package:meshwark_rider/app/constants.dart';
import 'package:meshwark_rider/presentation/bloc/bloc_observer.dart';
import 'package:meshwark_rider/presentation/resources/language_manager.dart';
import 'app/app.dart';
import 'app/di.dart';
import 'data/network/dio_helper.dart';
import 'app/secure_token_storage.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void fetchDataAndUpdateConstants() async {
  final AppPreferences appPreferences = instance();
  Constants.id = await appPreferences.getUserId(key: 'userId') ?? "";
  Constants.token = await SecureTokenStorage.readToken() ?? "";
  Constants.isBoarding = await appPreferences.getBoarding(key: 'boarding') ?? 0;
  Constants.firstName =
      await appPreferences.getFirstName(key: 'firstName') ?? "";
  Constants.lastName = await appPreferences.getLastName(key: 'lastName') ?? "";
  if (kDebugMode) {
   
  }
}

String? fcmToken;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app module
  await initAppModule();

  // Fetch data and update constants
  fetchDataAndUpdateConstants();

  // EasyLocalization initialization
  await EasyLocalization.ensureInitialized();

  // Set up HTTP overrides
  HttpOverrides.global = MyHttpOverrides();

  // Load and set trusted certificates
  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  // Set up Bloc observer
  Bloc.observer = MyBlocObserver();

  // Initialize Dio helper
  DioHelper.init();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (kDebugMode) {
   
  }

  runApp(ScreenUtilInit(
    designSize: const Size(360, 690),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, child) {
      return EasyLocalization(
        supportedLocales: const [ARABIC_LOCALE, ENGLISH_LOCALE],
        path: ASSET_PATH_LOCALE,
        child: Phoenix(child: MyApp()),
      );
    },
  ));
}
