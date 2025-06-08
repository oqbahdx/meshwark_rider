import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:meshwark_rider/app/app_pref.dart';
import 'package:meshwark_rider/app/constants.dart';
import 'package:meshwark_rider/app/di.dart';

import 'package:meshwark_rider/presentation/bloc/profile_bloc/profile_cubit.dart';
import 'package:meshwark_rider/presentation/bloc/select_service_bloc/select_service_cubit.dart';
import 'package:meshwark_rider/presentation/resources/assets_manager.dart';
import 'dart:io' show Platform;
import '../resources/Strings_manager.dart';
import '../resources/color_manager.dart';
import '../resources/fonts_manager.dart';
import '../resources/language_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/style_manager.dart';
import '../resources/value_manager.dart';
import 'widgets/account_information_widgets.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  TextEditingController? _firstNameController;

  TextEditingController? _lastNameController;
  final _key = GlobalKey<FormState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fToast.init(context);

    _appPreferences.getFirstName(key: 'firstName').then((value) {
      Constants.firstName = value!;
    });
    _appPreferences.getLastName(key: 'lastName').then((value) {
      Constants.lastName = value!;
    });
    _firstNameController = TextEditingController(text: Constants.firstName);
    _lastNameController = TextEditingController(text: Constants.lastName);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        leading: Platform.isAndroid
            ? IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<ProfileCubit>().image = null;
                },
                icon: const Icon(Icons.arrow_back))
            : IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<ProfileCubit>().image = null;
                },
                icon: const Icon(Icons.arrow_back_ios)),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorManager.white,
            statusBarIconBrightness: Brightness.dark),
        backgroundColor: ColorManager.white,
        elevation: AppSize.s0,
        title: Text(
          AppStrings.profile.tr(),
          style: getBoldStyle(
              color: ColorManager.primary,
              fontSize: isRTL() ? FontSize.s22.sp : FontSize.s20.sp),
        ),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdateSuccessState) {
              Navigator.of(context).pushReplacementNamed(Routes.selectServiceRoute);
            }
          },
          builder: (context, state) {
            var cubit = context.read<ProfileCubit>();
            if (state is ProfileUpdateLoadingState) {
              return Center(
                  child: Lottie.asset(JsonAssets.profile,
                      height: width * 0.3, width: width * 0.3));
            }
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
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: width * 0.4,
                              height: width * 0.4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorManager.lightGrey,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: cubit.image == null
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${context.read<SelectServiceCubit>().userModel?.data?.personalImagePath}",
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(
                                          color: ColorManager.primary,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                          Icons.person,
                                          size: width * 0.2,
                                          color: ColorManager.darkGrey,
                                        ),
                                      ),
                                    )
                                  : ClipOval(
                                      child: Image.file(
                                        cubit.image!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: width * 0.3,
                              child: InkWell(
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
                                    context: context,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: ColorManager.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: ColorManager.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            if (cubit.image != null)
                              Positioned(
                                top: 0,
                                right: width * 0.3,
                                child: InkWell(
                                  onTap: () {
                                    cubit.deleteProfileImage();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: ColorManager.error,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: ColorManager.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                     _buildRatingAndTrips(),
                        SizedBox(
                          height: height * 0.045,
                        ),
                        BuildTextFormFieldNoBorder(
                          controller: _firstNameController!,
                          labelText: AppStrings.firstName.tr(),
                          hintText: AppStrings.firstName.tr(),
                          icon: Icons.person,
                          inputType: TextInputType.name,
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
                        ),
                        SizedBox(
                          height: height * 0.045,
                        ),
                        SizedBox(
                          height: height * 0.1,
                        ),
                        SizedBox(
                          height: height * 0.06,
                          width: width * 0.5,
                          child: state is ProfileUpdateLoadingState ? Center(
                            child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation(
                            ColorManager.primary),

                            ),
                          ): ElevatedButton(
                            onPressed: () {
                              if (_key.currentState!.validate()) {
                                if (cubit.image != null) {
                                  cubit.updateProfileWithImage(
                                    firstName: _firstNameController!
                                        .text
                                        .trim(),
                                    lastName: _lastNameController!.text
                                        .trim(),
                                  );
                                } else {
                                  cubit.updateProfile(
                                    firstName: _firstNameController!
                                        .text
                                        .trim(),
                                    lastName: _lastNameController!.text
                                        .trim(),
                                  );
                                }
                              }
                            },
                            child: Text(
                              AppStrings.update.tr(),
                              style: getBoldStyle(
                                color: ColorManager.white,
                                fontSize: isRTL()
                                    ? FontSize.s18.sp
                                    : FontSize.s16.sp,
                              ),
                            ),
                          )),

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
  Widget _buildRatingAndTrips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 32.sp),
            SizedBox(height: 8.h),
            Text(
              "${context.read<SelectServiceCubit>().userModel?.data?.rating?? 0 }",
              style: getBoldStyle(
                color: ColorManager.primary,
                fontSize: FontSize.s20.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              AppStrings.rating.tr(),
              style: getRegularStyle(
                color: ColorManager.grey,
                fontSize: FontSize.s14.sp,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Icon(Icons.commute, color: ColorManager.primary, size: 32.sp),
            SizedBox(height: 8.h),
            Text(
              "${context.read<SelectServiceCubit>().userModel?.data?.canceledTrips ?? 0}",
              style: getBoldStyle(
                color: ColorManager.primary,
                fontSize: FontSize.s20.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              AppStrings.totalTrips.tr(),
              style: getRegularStyle(
                color: ColorManager.grey,
                fontSize: FontSize.s14.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorManager.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 30, color: ColorManager.primary),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getRegularStyle(
                    color: ColorManager.darkGrey,
                    fontSize: FontSize.s14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: getBoldStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
