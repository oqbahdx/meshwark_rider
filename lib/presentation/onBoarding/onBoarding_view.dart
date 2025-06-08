import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:meshwark_rider/presentation/login/login_view.dart';
import 'package:meshwark_rider/presentation/resources/Strings_manager.dart';
import 'package:meshwark_rider/presentation/resources/color_manager.dart';
import 'package:meshwark_rider/presentation/resources/fonts_manager.dart';
import 'package:meshwark_rider/presentation/resources/style_manager.dart';
import 'package:meshwark_rider/presentation/resources/value_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app/app_pref.dart';
import '../../app/di.dart';
import '../resources/assets_manager.dart';
import '../resources/language_manager.dart';
import 'dart:io' as io;

final AppPreferences _appPreferences = instance<AppPreferences>();

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  _OnBoardingViewState createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    _appPreferences.setBoarding(key: 'boarding', value: 1);
    if (await Permission.location.request().isGranted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );

    } else {
      await Permission.location.request();
    }
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
                statusBarIconBrightness: Brightness.dark),
          )),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: _buildImage(JsonAssets.lookingForCar, width),
            ),
          ),
          Expanded(
            child: SizedBox(
              child: IntroductionScreen(
                key: introKey,
                globalBackgroundColor: Colors.white,
                pages: [
                  PageViewModel(
                    title: AppStrings.onBoardingPageTitle1.tr(),
                    body: AppStrings.onBoardingPageSub1.tr(),
                    // image: _buildImage(JsonAssets.lookingForCar, width),
                    decoration: pageDecoration,
                  ),
                  PageViewModel(
                    title: AppStrings.onBoardingPageTitle2.tr(),
                    body: AppStrings.onBoardingPageSub2.tr(),
                    // image: _buildImage(JsonAssets.lookingForCar, width),
                    decoration: pageDecoration,
                  ),
                  PageViewModel(
                    title: AppStrings.onBoardingPageTitle3.tr(),
                    body: AppStrings.onBoardingPageSub3.tr(),
                    // image: _buildImage(JsonAssets.lookingForCar, width),
                    decoration: pageDecoration,
                  ),
                ],
                onDone: () => _onIntroEnd(context),
                //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
                showSkipButton: false,
                skipOrBackFlex: AppSize.si0,
                nextFlex: AppSize.si0,
                showBackButton: true,
                //rtl: true, // Display as right-to-left
                back: Icon(
                  color: ColorManager.white,
                    io.Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
                skip: Text(AppStrings.skip.tr(),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                next: Icon(
                    color: ColorManager.white,
                    io.Platform.isAndroid
                    ? Icons.arrow_forward
                    : Icons.arrow_forward_ios),
                done: Text(AppStrings.done.tr(),
                    style: getSemiBoldStyle(
                        color: ColorManager.white,
                        fontSize: isRTL() ? FontSize.s16.sp : FontSize.s18.sp)),
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
          ),
        ],
      ),
    );
  }

  bool isRTL() {
    return context.locale == ARABIC_LOCALE;
  }
}
