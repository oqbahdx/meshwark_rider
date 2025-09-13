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
import 'package:meshwark_rider/app/di.dart';
import 'package:http/http.dart' as http;
import '../../../app/constants.dart';
import '../../../data/network/dio_helper.dart';
import '../../resources/Strings_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';

part 'add_profile_state.dart';

class AddProfileCubit extends Cubit<AddProfileState> {
  AddProfileCubit() : super(AddProfileInitial());
  FToast fToast = FToast();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final picker = ImagePicker();
  File? image;
  Future getImage(ImageSource src) async {
    final pickedFile = await picker.pickImage(
        source: src, imageQuality: 80, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(UploadImageState());
    }
    if (kDebugMode) {
     
    }
    emit(UploadImageState());
  }

  bool isMan = true;
  void changeGender(bool value) {
    isMan = value;
    emit(ChangeGenderState());
  }
    Future<bool> hasInternetAccess() async {
    try {
      final result = await http.get(Uri.parse('https://www.google.com')).timeout(const Duration(seconds: 3));
      return result.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
  Future<void> addProfile({
    required String firstName,
    required String lastName,
    required String gender,
  }) async {
    final connected = await hasInternetAccess();
    if (connected) {
      DioHelper.init();
      emit(AddProfileLoadingState());

      String userId = await _appPreferences.getUserId(key: "userId") ?? "";
      Constants.id = userId;

      DioHelper.postDataWithImage(
          endPoint: "${Constants.updateUserEndPoint}/${Constants.id}",
          data: FormData.fromMap({
            "personalImage": MultipartFile.fromFileSync(image!.path,
                filename: image!.path.split("/").last.replaceAll(' ', '_')),
            "firstName": firstName,
            "lastName": lastName,
            "isActive": true,
            "gender": gender
          })).then((value) {
        emit(AddProfileSuccessState());
      });
    } else {
      showNoInternetMessage();
    }
  }

  showNoInternetMessage() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s10),
        color: ColorManager.textFormDarkGrey,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi),
          const SizedBox(
            width: 12.0,
          ),
          Text(
            AppStrings.noInternetConnection.tr(),
            style: getBoldStyle(color: ColorManager.black),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 4),
    );
  }

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
}
