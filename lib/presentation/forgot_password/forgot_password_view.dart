import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meshwark_rider/presentation/resources/Strings_manager.dart';
import '../register/widgets/register_widgets.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/fonts_manager.dart';
import '../resources/language_manager.dart';
import '../resources/style_manager.dart';
import '../resources/value_manager.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  TextEditingController? _numberController;

  final GlobalKey _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark),
        // leading: IconButton(
        //     icon: io.Platform.isAndroid
        //         ? const Icon(Icons.arrow_back)
        //         : const Icon(Icons.arrow_back_ios),
        //     onPressed: () {
        //       Navigator.pushReplacementNamed(context, Routes.loginRoute);
        //     }),
        elevation: AppSize.s0,
        backgroundColor: ColorManager.transparent,
        title: Text(
          AppStrings.forgotPassword.tr(),
          style: getBoldStyle(
              color: ColorManager.primary, fontSize: FontSize.s16.sp),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
            child: Form(
              key: _globalKey,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Image.asset(
                    ImageAssets.appLogoNew,
                    height: width * 0.35.w,
                    width: width * 0.35.w,
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Text(
                    AppStrings.enterYourPhoneNumber.tr(),
                    style: getSemiBoldStyle(
                        color: ColorManager.primary, fontSize: FontSize.s16.sp),
                  ),
                  SizedBox(
                    height: height * 0.1,
                  ),
                  BuildFormField(
                      isSecure: false,
                      maxLength: 10,
                      controller: _numberController!,
                      text: AppStrings.number.tr(),
                      icon: const Icon(Icons.phone),
                      inputType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppStrings.thisFieldIsRequired.tr();
                        }
                        if (value.length < 10) {
                          return AppStrings.numberIsShort.tr();
                        }
                        return null;
                      },
                      fontSize: isRTL() ? FontSize.s18.sp : FontSize.s16.sp),
                  SizedBox(
                    height: height * 0.2,
                  ),
                  SizedBox(
                      height: height * 0.06,
                      width: width * 0.5.w,
                      child: ElevatedButton(
                          onPressed: () {
                            // todo : reset password function
                          },
                          child: Text(
                            AppStrings.resetPassword.tr(),
                            style: getSemiBoldStyle(
                                color: ColorManager.white,
                                fontSize: FontSize.s18.sp),
                          )))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isRTL() {
    return context.locale == ARABIC_LOCALE;
  }

  @override
  void dispose() {
    _numberController!.dispose();
    super.dispose();
  }
}
