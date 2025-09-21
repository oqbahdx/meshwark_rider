import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../app/app_pref.dart';
import '../../app/di.dart';
import '../login/login_view.dart';
import '../resources/Strings_manager.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/fonts_manager.dart';
import '../resources/style_manager.dart';
import '../resources/value_manager.dart';
import '../resources/language_manager.dart';
import 'dart:io' as io;

final AppPreferences _appPreferences = instance<AppPreferences>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  _OnBoardingViewState createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Future<void> requestNotificationPermission() async {
    try {
      InitializationSettings initializationSettings;

      if (io.Platform.isAndroid) {
        // ✅ Android-only initialization
        const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

        initializationSettings = const InitializationSettings(
          android: initializationSettingsAndroid,
        );
      } else if (io.Platform.isIOS) {
        // ✅ iOS-only initialization
        const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

        initializationSettings = const InitializationSettings(
          iOS: initializationSettingsDarwin,
        );
      } else {
        // For other platforms, use minimal settings
        initializationSettings = const InitializationSettings();
      }

      // ✅ Initialize plugin with platform-specific settings
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      if (io.Platform.isIOS) {
        // iOS: ask explicitly for permissions
        final bool? result = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        debugPrint("iOS notification permission: $result");
      } else if (io.Platform.isAndroid) {
        // Android 13+ requires runtime permission
        final status = await Permission.notification.request();
        if (status.isGranted) {
          debugPrint("Android notification permission granted ✅");
        } else {
          debugPrint("Android notification permission denied ❌");
        }
      }
    } catch (e) {
      debugPrint("⚠️ Notification init failed: $e");
    }
  }

  Future<void> _onIntroEnd(context) async {
    _appPreferences.setBoarding(key: 'boarding', value: 1);

    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      // ✅ Ask for notification permission after location
      await requestNotificationPermission();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      }
    } else {
      await _showLocationPermissionDialog(context);
    }
  }

  Future<void> _showLocationPermissionDialog(BuildContext context) async {
    if (!mounted) return;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Location Permission Required',
            style: getBoldStyle(
              color: ColorManager.black,
              fontSize: FontSize.s18,
            ),
          ),
          content: Text(
            'This app needs access to your location to show your current position on the map and provide navigation services. Please enable location permission in Settings.',
            style: getRegularStyle(
              color: ColorManager.black,
              fontSize: FontSize.s14,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: getSemiBoldStyle(
                  color: ColorManager.grey,
                  fontSize: FontSize.s14,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: Text(
                'Open Settings',
                style: getSemiBoldStyle(
                  color: ColorManager.primary,
                  fontSize: FontSize.s14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImage(String assetName, double width) {
    return Lottie.asset(assetName, width: width);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    TextStyle bodyStyle =
    getSemiBoldStyle(color: ColorManager.black, fontSize: FontSize.s20);

    var pageDecoration = PageDecoration(
      titleTextStyle:
      getBoldStyle(color: ColorManager.black, fontSize: FontSize.s30),
      bodyTextStyle: bodyStyle,
      bodyPadding: const EdgeInsets.fromLTRB(
          AppPadding.p16, AppPadding.p0, AppPadding.p16, AppPadding.p16),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(AppSize.s0),
        child: AppBar(
          elevation: AppSize.s0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorManager.white,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: _buildImage(JsonAssets.lookingForCar, width),
            ),
          ),
          Expanded(
            child: IntroductionScreen(
              key: introKey,
              globalBackgroundColor: Colors.white,
              pages: [
                PageViewModel(
                  title: AppStrings.onBoardingPageTitle1.tr(),
                  body: AppStrings.onBoardingPageSub1.tr(),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  title: AppStrings.onBoardingPageTitle2.tr(),
                  body: AppStrings.onBoardingPageSub2.tr(),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  title: AppStrings.onBoardingPageTitle3.tr(),
                  body: AppStrings.onBoardingPageSub3.tr(),
                  decoration: pageDecoration,
                ),
              ],
              onDone: () => _onIntroEnd(context),
              showSkipButton: false,
              skipOrBackFlex: AppSize.si0,
              nextFlex: AppSize.si0,
              showBackButton: true,
              back: Icon(
                io.Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios,
                color: ColorManager.white,
              ),
              next: Icon(
                io.Platform.isAndroid
                    ? Icons.arrow_forward
                    : Icons.arrow_forward_ios,
                color: ColorManager.white,
              ),
              done: Text(
                AppStrings.done.tr(),
                style: getSemiBoldStyle(
                  color: ColorManager.white,
                  fontSize: isRTL() ? FontSize.s16.sp : FontSize.s18.sp,
                ),
              ),
              curve: Curves.fastLinearToSlowEaseIn,
              controlsMargin: const EdgeInsets.all(AppMargin.m16),
              controlsPadding: kIsWeb
                  ? const EdgeInsets.all(AppPadding.p12)
                  : const EdgeInsets.fromLTRB(
                  AppPadding.p8, AppPadding.p4, AppPadding.p8, AppPadding.p4),
              dotsDecorator: const DotsDecorator(
                size: Size(AppSize.s10, AppSize.s10),
                color: Color(0xFFBDBDBD),
                activeSize: Size(AppSize.s22, AppSize.s10),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(AppSize.s25)),
                ),
              ),
              dotsContainerDecorator: const ShapeDecoration(
                color: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(AppSize.s8)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isRTL() {
    return context.locale == ARABIC_LOCALE;
  }
}