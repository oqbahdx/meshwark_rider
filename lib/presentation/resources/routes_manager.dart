import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meshwark_rider/presentation/about_app/about_app_view.dart';
import 'package:meshwark_rider/presentation/add_profile/add_profile.dart';
import 'package:meshwark_rider/presentation/profile/profile_view.dart';
import 'package:meshwark_rider/presentation/customer_support/customer_support_view.dart';
import 'package:meshwark_rider/presentation/trip_history/trip_history_view.dart';
import 'package:meshwark_rider/presentation/language/language_view.dart';
import 'package:meshwark_rider/presentation/login/login_view.dart';
import 'package:meshwark_rider/presentation/main_account/main_account_view.dart';
import 'package:meshwark_rider/presentation/map/map_view.dart';
import 'package:meshwark_rider/presentation/notification/notification_view.dart';
import 'package:meshwark_rider/presentation/onBoarding/onBoarding_view.dart';
import 'package:meshwark_rider/presentation/otp_screen/otp_view.dart';
import 'package:meshwark_rider/presentation/register/register_view.dart';
import 'package:meshwark_rider/presentation/select_gender/select_gender_view.dart';
import 'package:meshwark_rider/presentation/select_truck/select_truck_view.dart';

import '../forgot_password/forgot_password_view.dart';
import '../map/widgets/map_widgets.dart';
import '../wallet/wallet_view.dart';
import '../select_service/select_service_view.dart';
import 'Strings_manager.dart';
import 'dart:io';

class Routes {
  static const String splashRoute = "/";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String onBoardingRoute = "/onBoarding";
  static const String mapPageRoute = "/mapPage";
  static const String mainAccountRoute = "/mainAccount";
  static const String selectServiceRoute = "/selectService";
  static const String selectGenderRoute = "/selectGender";
  static const String otpRoute = "/otp";
  static const String accountInformationRoute = "/accountInformation";
  static const String changeLanguageRoute = "/changeLanguage";
  static const String notificationRoute = "/notification";
  static const String historyRoute = "/history";
  static const String customerSupportRoute = "/customerSupport";
  static const String myDrawerRoute = "/myDrawer";
  static const String selectTrucRoute = "/selectTruc";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String walletRoute = "/wallet";
  static const String aboutAppRoute = "/aboutApp";
  static const String addRiderProfileRoute = "/addProfile";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginRoute:
        return _getPageRoute(const LoginView());
      case Routes.registerRoute:
        return _getPageRoute(const RegisterView());
      case Routes.onBoardingRoute:
        return _getPageRoute(const OnBoardingView());
      case Routes.mapPageRoute:
        return _getPageRoute(const MapPageView(
          image: '',
          tag: '',
          gender: '',
          typeOfTrip: '',
        ));
      case Routes.mainAccountRoute:
        return _getPageRoute(const MainAccountView());
      case Routes.selectServiceRoute:
        return _getPageRoute(const SelectServiceView());
      case Routes.selectGenderRoute:
        return _getPageRoute(const SelectGenderView(
          tag: '',
          image: '',
        ));
      case Routes.otpRoute:
        return _getPageRoute(const OTPView(number: ''));
      case Routes.accountInformationRoute:
        return _getPageRoute(const ProfileView());
      case Routes.changeLanguageRoute:
        return _getPageRoute(const LanguageView());
      case Routes.notificationRoute:
        return _getPageRoute(const NotificationView());
      case Routes.historyRoute:
        return _getPageRoute(const TripHistoryView());
      case Routes.customerSupportRoute:
        return _getPageRoute(const CustomerSupportView());
      case Routes.myDrawerRoute:
        return _getPageRoute(const CustomDrawer());
      case Routes.selectTrucRoute:
        return _getPageRoute(const SelectTruckView());
      case Routes.forgotPasswordRoute:
        return _getPageRoute(const ForgotPasswordView());
      case Routes.walletRoute:
        return _getPageRoute(const WalletView());
      case Routes.aboutAppRoute:
        return _getPageRoute(const AboutAppView());
      case Routes.addRiderProfileRoute:
        return _getPageRoute(const AddProfileView());
      default:
        return pageNotFound();
    }
  }

  static Route<dynamic> _getPageRoute(Widget page) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: (_) => page);
    } else {
      return MaterialPageRoute(builder: (_) => page);
    }
  }

  static Route<dynamic> pageNotFound() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.pageNotFound.tr()),
        ),
        body: Center(child: Text(AppStrings.pageNotFound.tr())),
      ),
    );
  }
}
