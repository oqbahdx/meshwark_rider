import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meshwark_rider/app/app_pref.dart';
import 'package:meshwark_rider/presentation/bloc/login_bloc/login_cubit.dart';
import 'package:meshwark_rider/presentation/resources/Strings_manager.dart';
import 'package:meshwark_rider/presentation/resources/assets_manager.dart';
import 'package:meshwark_rider/presentation/resources/color_manager.dart';
import 'package:meshwark_rider/presentation/resources/fonts_manager.dart';
import 'package:meshwark_rider/presentation/resources/language_manager.dart';
import 'package:meshwark_rider/presentation/resources/style_manager.dart';
import 'package:meshwark_rider/presentation/resources/value_manager.dart';

import '../../app/constants.dart';
import '../../app/di.dart';
import '../register/widgets/register_widgets.dart';
import '../resources/routes_manager.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController? _numberController;
  TextEditingController? _passwordController;
  final GlobalKey<FormState> _globalKey = GlobalKey();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void initState() {
    super.initState();
    context.read<LoginCubit>().fToast.init(context);
    _numberController = TextEditingController();
    _passwordController = TextEditingController();
    _appPreferences.getBoarding(key: 'boarding').then((value) {
      Constants.isBoarding = value ?? 0;
    });
    if (kDebugMode) {
    
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    var cubit = context.read<LoginCubit>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark),
        ),
      ),
      backgroundColor: ColorManager.white,
      body: SafeArea(
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginErrorState) {
              cubit.showErrorMessage(
                  message: AppStrings.phoneNumberOrPasswordInvalid.tr(),
                  context: context);
            }
            if (state is LoginSuccessState) {
              if (cubit.loginModel?.success == true &&
                  context.read<LoginCubit>().loginModel?.data?.hasProfile != false) {
                _appPreferences.setUserLoggedIn();
                Navigator.pushReplacementNamed(
                    context, Routes.selectServiceRoute);
              } else if (cubit.loginModel?.message ==
                  "Driver login successful") {
                cubit.showErrorMessage(
                    message: AppStrings.phoneNumberOrPasswordInvalid.tr(),
                    context: context);
              } else {
                Navigator.pushReplacementNamed(
                    context, Routes.addRiderProfileRoute);
              }
              // cubit.getUserData();
            }
          },
          builder: (context, state) {
            // var cubit = AppCubit.get(context);
            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p28),
                  child: Form(
                    key: _globalKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: AppSize.s40.h,
                        ),
                        Image.asset(
                          ImageAssets.appLogoNew,
                          height: width * 0.35.w,
                          width: width * 0.35.w,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        InkWell(
                          onTap: !isRTL()
                              ? () {
                                  _appPreferences.changeAppLanguage();
                                  Phoenix.rebirth(context);
                                }
                              : () {
                                  _appPreferences.changeAppLanguage();
                                  Phoenix.rebirth(context);
                                },
                          child: Text(
                            AppStrings.changeLanguage.tr(),
                            style: getSemiBoldStyle(
                                color: isRTL()
                                    ? ColorManager.primary
                                    : ColorManager.grey,
                                fontSize: isRTL()
                                    ? FontSize.s16.sp
                                    : FontSize.s14.sp),
                          ),
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
                            fontSize:
                                isRTL() ? FontSize.s18.sp : FontSize.s16.sp),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        BuildFormField(
                            isSecure: cubit.isSecure,
                            controller: _passwordController!,
                            text: AppStrings.password.tr(),
                            icon: IconButton(
                                splashColor: ColorManager.transparent,
                                onPressed: () => cubit.changePasswordVisible(),
                                icon: Icon(cubit.isSecure
                                    ? Icons.remove_red_eye
                                    : Icons.remove_red_eye_outlined)),
                            inputType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppStrings.thisFieldIsRequired.tr();
                              }
                              return null;
                            },
                            fontSize:
                                isRTL() ? FontSize.s18.sp : FontSize.s16.sp),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              AppStrings.forgotPassword.tr(),
                              style: getBoldStyle(
                                  color: ColorManager.grey,
                                  fontSize: isRTL()
                                      ? FontSize.s16.sp
                                      : FontSize.s14.sp),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Routes.forgotPasswordRoute);
                                },
                                child: Text(
                                  AppStrings.clickHere.tr(),
                                  style: getBoldStyle(
                                      color: ColorManager.primary,
                                      fontSize: isRTL()
                                          ? FontSize.s16.sp
                                          : FontSize.s14.sp),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: height * 0.08,
                        ),
                        SizedBox(
                            height: height * 0.06,
                            width: width * 0.5,
                            child: state is LoginLoadingState
                                ? Center(
                                    child: CircularProgressIndicator.adaptive(
                                    backgroundColor: ColorManager.white,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        ColorManager.primary),
                                  ))
                                : ElevatedButton(
                                    onPressed: () {
                                      if (_globalKey.currentState!.validate()) {
                                        cubit.login(
                                            phone: _numberController!.text,
                                            password:
                                                _passwordController!.text);
                                      }
                                    },
                                    child: Text(
                                      AppStrings.login.tr(),
                                      style: getBoldStyle(
                                          color: ColorManager.white,
                                          fontSize: isRTL()
                                              ? FontSize.s20.sp
                                              : FontSize.s18.sp),
                                    ))),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.doNotHaveAnAccount.tr(),
                              style: getBoldStyle(
                                  color: ColorManager.grey,
                                  fontSize: isRTL()
                                      ? FontSize.s18.sp
                                      : FontSize.s16.sp),
                            ),
                            SizedBox(
                              width: width * 0.1,
                            ),
                            TextButton(
                              child: Text(
                                AppStrings.signUp.tr(),
                                style: getBoldStyle(
                                    color: ColorManager.primary,
                                    fontSize: isRTL()
                                        ? FontSize.s18.sp
                                        : FontSize.s16.sp),
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(Routes.registerRoute);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _numberController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  bool isRTL() {
    return context.locale == ARABIC_LOCALE;
  }
}
