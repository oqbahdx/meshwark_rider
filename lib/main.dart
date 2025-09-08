import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
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
    print("is boarding from main : ${Constants.isBoarding}");
    print("user id from main : ${Constants.id}");
  }
}

String? fcmToken;

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase Messaging setup
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  try {
    fcmToken = await messaging.getToken();
    print("fcm token: $fcmToken");
  } catch (e) {
    print("Failed to retrieve FCM token: $e");
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
    print("user id =  : ${Constants.id}");
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
