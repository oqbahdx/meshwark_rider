
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/add_profile/add_profile_cubit.dart';
import '../bloc/profile_bloc/profile_cubit.dart';
import '../profile/widgets/account_information_widgets.dart';
import '../resources/Strings_manager.dart';
import '../resources/color_manager.dart';
import '../resources/fonts_manager.dart';
import '../resources/language_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/style_manager.dart';
import '../resources/value_manager.dart';

class AddProfileView extends StatefulWidget {
  const AddProfileView({super.key});

  @override
  State<AddProfileView> createState() => _AddProfileViewState();
}

class _AddProfileViewState extends State<AddProfileView> {
  TextEditingController? _firstNameController;

  TextEditingController? _lastNameController;

  final _key = GlobalKey<FormState>();
  String gender = "";
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fToast.init(context);
    _firstNameController = TextEditingController();

    _lastNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        leading: Container(),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorManager.white,
            statusBarIconBrightness: Brightness.dark),
        backgroundColor: ColorManager.white,
        elevation: AppSize.s0,
        title: Text(
          AppStrings.addProfile.tr(),
          style: getBoldStyle(
              color: ColorManager.primary,
              fontSize: isRTL() ? FontSize.s22.sp : FontSize.s20.sp),
        ),
      ),
      body: BlocConsumer<AddProfileCubit, AddProfileState>(
          listener: (context, state) {
        if (state is AddProfileSuccessState) {
          Navigator.pushReplacementNamed(context, Routes.selectServiceRoute);
        }
      }, builder: (context, state) {
        var cubit = context.read<AddProfileCubit>();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.05,
                    ),
                    cubit.image == null
                        ? InkWell(
                            splashColor: ColorManager.transparent,
                            highlightColor: ColorManager.transparent,
                            onTap: () {
                              cubit.getAlertDialog(
                                  onTapCam: () {
                                    cubit
                                        .getImage(ImageSource.camera)
                                        .then((value) {
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  onTapGal: () {
                                    cubit
                                        .getImage(ImageSource.gallery)
                                        .then((value) {
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  context: context);
                            },
                            child: Card(
                              shadowColor: ColorManager.primary,
                              elevation: AppSize.s2,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s25)),
                              child: Container(
                                height: width * 0.35,
                                width: width * 0.35,
                                decoration: BoxDecoration(
                                  color: ColorManager.white,
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s25),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s25),
                                  child: Icon(
                                    Icons.add,
                                    size: AppSize.s40,
                                    color: ColorManager.primary,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Stack(
                            children: [
                              Card(
                                elevation: AppSize.s4,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(AppSize.s25)),
                                child: Container(
                                  height: width * 0.35,
                                  width: width * 0.35,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(AppSize.s25),
                                  ),
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(AppSize.s25),
                                      child: Image.file(
                                        cubit.image!,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  cubit.getAlertDialog(
                                      onTapCam: () {
                                        cubit
                                            .getImage(ImageSource.camera)
                                            .then((value) {
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      onTapGal: () {
                                        cubit
                                            .getImage(ImageSource.gallery)
                                            .then((value) {
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      context: context);
                                },
                                icon: const Icon(
                                  Icons.edit,
                                ),
                                color: ColorManager.error,
                              )
                            ],
                          ),
                    SizedBox(
                      height: height * 0.045,
                    ),
                    BuildTextFormFieldNoBorder(
                      controller: _firstNameController!,
                      labelText: AppStrings.firstName.tr(),
                      hintText: AppStrings.firstName.tr(),
                      icon: Icons.person,
                      inputType: TextInputType.name,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return AppStrings.thisFieldIsRequired.tr();
                        }
                        if (value.length < 2) {
                          return AppStrings.firstNameError.tr();
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: height * 0.045,
                    ),
                    BuildTextFormFieldNoBorder(
                      controller: _lastNameController!,
                      labelText: AppStrings.lastName.tr(),
                      hintText: AppStrings.lastName.tr(),
                      icon: Icons.person,
                      inputType: TextInputType.name,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return AppStrings.thisFieldIsRequired.tr();
                        }
                        if (value.length < 2) {
                          return AppStrings.lastNameError.tr();
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.woman,
                          size: AppSize.s30,
                          color: ColorManager.pink,
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        SizedBox(
                          width: AppSize.s80.w,
                          child: Switch.adaptive(
                              activeColor: ColorManager.primary,
                              inactiveTrackColor: ColorManager.pink,
                              inactiveThumbColor: ColorManager.white,
                              value: cubit.isMan,
                              onChanged: (value) => cubit.changeGender(value)),
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        Icon(
                          Icons.man,
                          size: AppSize.s30,
                          color: ColorManager.primary,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    SizedBox(
                      height: height * 0.06,
                      width: width * 0.5,
                      child: state is AddProfileLoadingState
                          ? Center(
                              child: CircularProgressIndicator.adaptive(
                                valueColor: AlwaysStoppedAnimation(
                                    ColorManager.primary),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                if (_key.currentState!.validate()) {
                                  cubit.addProfile(
                                      firstName:
                                          _firstNameController!.text.trim(),
                                      lastName:
                                          _lastNameController!.text.trim(),
                                      gender: cubit.isMan ? "man" : "woman");
                                }
                              },
                              child: Text(
                                AppStrings.add.tr(),
                                style: getSemiBoldStyle(
                                    color: ColorManager.white,
                                    fontSize: FontSize.s20),
                              )),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  bool isRTL() {
    return context.locale == ARABIC_LOCALE;
  }

  @override
  void dispose() {
    _firstNameController!.dispose();
    _lastNameController!.dispose();
    super.dispose();
  }
}
