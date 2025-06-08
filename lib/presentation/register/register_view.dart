import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meshwark_rider/main.dart';

import 'package:meshwark_rider/presentation/bloc/register_bloc/register_cubit.dart';
import 'package:meshwark_rider/presentation/register/widgets/register_widgets.dart';
import 'package:meshwark_rider/presentation/resources/color_manager.dart';
import 'package:meshwark_rider/presentation/resources/value_manager.dart';
import '../resources/Strings_manager.dart';
import '../resources/assets_manager.dart';
import '../resources/fonts_manager.dart';
import '../resources/language_manager.dart';
import '../resources/style_manager.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _globalKey = GlobalKey();
  TextEditingController? _numberController;
  TextEditingController? _passwordController;
  TextEditingController? _emailController;

  @override
  void initState() {
    super.initState();
    context.read<RegisterCubit>().fToast.init(context);
    _numberController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    print("fcm token from reigster page : $fcmToken");
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    var cubit = context.read<RegisterCubit>();
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          if (cubit.registerModel?.code ==
              200) {

            cubit.showSuccessMessage(message: AppStrings.userRegisterSuccessfully.tr(), context: context);
            Navigator.of(context).pop();
          }
        }
        if (state is RegisterErrorState) {
          cubit.showErrorMessage(
              message: AppStrings.numberOrEmailAreTaken.tr(), context: context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorManager.white,
          appBar: AppBar(
            backgroundColor: ColorManager.transparent,
            elevation: AppSize.s0,
            forceMaterialTransparency: true,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: ColorManager.white,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p28),
                  child: Form(
                    key: _globalKey,
                    child: Column(
                      children: [
                        Image.asset(
                          ImageAssets.appLogoNew,
                          height: width * 0.35.w,
                          width: width * 0.35.w,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(
                          height: height * 0.08,
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
                          height: height * 0.03,
                        ),
                        BuildFormField(
                            isSecure: false,
                            controller: _emailController!,
                            text: AppStrings.email.tr(),
                            icon: const Icon(Icons.email),
                            inputType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppStrings.thisFieldIsRequired.tr();
                              }
                              final bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(_emailController!.text);
                              if (!emailValid) {
                                return AppStrings.emailError.tr();
                              }
                              return null;
                            },
                            fontSize:
                                isRTL() ? FontSize.s18.sp : FontSize.s16.sp),
                        SizedBox(
                          height: height * 0.03,
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
                              if (value.length < 6) {
                                return AppStrings.passwordError.tr();
                              }
                              return null;
                            },
                            fontSize:
                                isRTL() ? FontSize.s18.sp : FontSize.s16.sp),
                        SizedBox(
                          height: height * 0.14,
                        ),
                        SizedBox(
                            height: height * 0.06,
                            width: width * 0.5,
                            child: state is RegisterLoadingState
                                ? Center(
                                    child: CircularProgressIndicator.adaptive(
                                      backgroundColor: ColorManager.white,
                                      valueColor: AlwaysStoppedAnimation<Color>(ColorManager.primary),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      if (_globalKey.currentState!.validate()) {
                                        cubit.register(
                                            number: _numberController!.text,
                                            email:
                                                _emailController!.text.trim(),
                                            password: _passwordController!.text
                                                .trim(),
                                            fcmToken: fcmToken.toString());
                                      }
                                    },
                                    child: Text(
                                      AppStrings.signUp.tr(),
                                      style: getBoldStyle(
                                          color: ColorManager.white,
                                          fontSize: isRTL()
                                              ? FontSize.s20.sp
                                              : FontSize.s18.sp),
                                    ),
                                  )),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.doYouHaveAnAccount.tr(),
                              style: getBoldStyle(
                                  color: ColorManager.grey,
                                  fontSize: isRTL()
                                      ? FontSize.s16.sp
                                      : FontSize.s14.sp),
                            ),
                            SizedBox(
                              width: width * 0.1,
                            ),
                            TextButton(
                              child: Text(
                                AppStrings.login.tr(),
                                style: getBoldStyle(
                                    color: ColorManager.primary,
                                    fontSize: isRTL()
                                        ? FontSize.s16.sp
                                        : FontSize.s14.sp),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _numberController!.dispose();
    _passwordController!.dispose();
    _emailController!.dispose();
    super.dispose();
  }

  bool isRTL() {
    return context.locale == ARABIC_LOCALE;
  }
}
