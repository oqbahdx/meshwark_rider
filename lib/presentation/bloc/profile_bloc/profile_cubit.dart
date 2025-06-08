
import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meshwark_rider/app/app_pref.dart';
import 'package:meshwark_rider/domain/update_model.dart';
import 'package:meshwark_rider/presentation/bloc/states.dart';

import '../../../app/constants.dart';
import '../../../app/di.dart';
import '../../../data/network/dio_helper.dart';

import '../../../domain/current_user_model.dart';
import '../../resources/Strings_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  FToast fToast = FToast();
  final AppPreferences appPreferences = instance<AppPreferences>();
  getAlertDialog(
      {required Function() onTapCam,
      required Function() onTapGal,
      required BuildContext context}) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return showGeneralDialog(
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (ctx, anim1, anim2) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s10)),
        backgroundColor: ColorManager.textFormDarkGrey,
        title: Align(
            alignment: Alignment.center,
            child: Text(AppStrings.pleaseSelectImage.tr())),
        elevation: 2,
        actions: [
          InkWell(
            onTap: onTapCam,
            child: Container(
              height: height * 0.065,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppPadding.p12),
                  color: ColorManager.textFormLightGrey),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(
                    Icons.camera_alt,
                    size: 40,
                  ),
                  Text(
                    AppStrings.camera.tr(),
                    style: getBoldStyle(
                        color: ColorManager.black, fontSize: FontSize.s16),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: onTapGal,
            child: Container(
              height: height * 0.065,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppPadding.p12),
                  color: ColorManager.textFormLightGrey),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(
                    Icons.image,
                    size: 40,
                  ),
                  Text(
                    AppStrings.gallery.tr(),
                    style: getBoldStyle(
                        color: ColorManager.black, fontSize: FontSize.s16),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: height * 0.055,
              width: width * 0.75,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.error),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppStrings.cancel.tr(),
                    style: getSemiBoldStyle(
                        color: ColorManager.white, fontSize: FontSize.s16.sp),
                  )),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
        ],
      ),
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
        child: FadeTransition(
          opacity: anim1,
          child: child,
        ),
      ),
      context: context,
    );
  }

  showMessage({required String message, required BuildContext context}) {
    fToast.init(context);
    Widget toast = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: ColorManager.primary,
      ),
      child: Text(
        message,
        style:
            TextStyle(color: ColorManager.white, fontWeight: FontWeight.bold),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  final picker = ImagePicker();
  File? image;
  Future getImage(ImageSource src) async {
    final pickedFile = await picker.pickImage(
        source: src, imageQuality: 80, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(ProfileUploadImageState());
    }
    if (kDebugMode) {
      print(image?.path.split('/').last);
    }
    emit(ProfileUploadImageState());
  }

  void deleteProfileImage() {
    image = null;
    emit(ProfileDeleteImageState());
  }

  UserModel? userModel;
  void updateProfileWithImage(
      {required String firstName, required String lastName}) async {
    List<ConnectivityResult> connectivityResult =
    await Connectivity().checkConnectivity();

    // Ensure it's either mobile or wifi connection
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      emit(ProfileUpdateLoadingState());
      var data = FormData.fromMap({
        "personalImage": MultipartFile.fromFileSync(image!.path,
            filename: "${image?.path.split('/').last}"),
        "firstName": firstName,
        "lastName": lastName,
      });
      DioHelper.updateDataWithImage(
          endPoint: "${Constants.updateUserEndPoint}/${Constants.id}",
          data: data)
          .then((value) {
        if (kDebugMode) {
          // userModel = GetUserModel.fromJson(value!.data);
          print(value.toString());
          appPreferences.setFirstName(
              key: 'firstName', value: userModel?.data?.firstName ?? "");
          // _appPreferences.setMiddleName(key: 'middleName', value: userModel?.middleName ?? "");
          appPreferences.setLastName(
              key: 'lastName', value: userModel?.data?.lastName ?? "");
        }
        emit(ProfileUpdateSuccessState());
      }).catchError((error) {
        emit(ProfileUpdateErrorState(error.toString()));
      });
    }
  }

  void updateProfile(
      {required String firstName, required String lastName}) async {
    List<ConnectivityResult> connectivityResult =
    await Connectivity().checkConnectivity();

    // Ensure it's either mobile or wifi connection
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      emit(ProfileUpdateLoadingState());
      var data = FormData.fromMap({
        "firstName": firstName,
        "lastName": lastName,
      });
      DioHelper.updateDataWithImage(
          endPoint: "${Constants.updateUserEndPoint}/${Constants.id}",
          data: data)
          .then((value) {
        if (kDebugMode) {
          // userModel = GetUserModel.fromJson(value!.data);
          print(value.toString());
          appPreferences.setFirstName(
              key: 'firstName', value: userModel?.data?.firstName ?? "");
          // _appPreferences.setMiddleName(key: 'middleName', value: userModel?.middleName ?? "");
          appPreferences.setLastName(
              key: 'lastName', value: userModel?.data?.lastName ?? "");
        }
        emit(ProfileUpdateSuccessState());
      }).catchError((error) {
        emit(ProfileUpdateErrorState(error.toString()));
      });
    }
  }
}
