import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:meshwark_rider/app/app_pref.dart';
import 'dart:io';
import '../../../app/constants.dart';
import '../../../app/di.dart';
import '../../../data/network/dio_helper.dart';
import '../../../domain/current_user_model.dart';
import '../../login/login_view.dart';
import '../../map/widgets/logout_widgets.dart';
import '../../resources/Strings_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';

part 'select_service_state.dart';

class SelectServiceCubit extends Cubit<SelectServiceState> {
  SelectServiceCubit() : super(SelectServiceInitial());
  FToast fToast = FToast();
  final AppPreferences _appPreferences = instance<AppPreferences>();
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

    Future<bool> hasInternetAccess() async {
    try {
      final result = await http.get(Uri.parse('https://www.google.com')).timeout(const Duration(seconds: 3));
      return result.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
  showWarringMessage({required String message, required BuildContext context}) {
    fToast.init(context);
    Widget toast = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: ColorManager.textFormLightGrey,
      ),
      child: Text(
        message,
        style:
        TextStyle(color: ColorManager.primary, fontWeight: FontWeight.bold),
      ),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
  UserModel? userModel;
  void getUserData() async {
  final connected = await hasInternetAccess();
    if (connected) {
      DioHelper.init();
      emit(GetUserLoadingState());
      DioHelper.getData(
              endPoint: "${Constants.getUserEndPoint}/${Constants.id}")
          .then((value) {
        userModel = UserModel.fromJson(value?.data);
      
        // _appPreferences.setUserId(key: 'userId', value: userModel?.id ?? "");
        _appPreferences.setFirstName(
            key: 'firstName', value: userModel?.data?.firstName ?? "");
        _appPreferences.setLastName(
            key: 'lastName', value: userModel?.data?.lastName ?? "");
        _appPreferences.setPhoneNumber(key: 'phoneNumber', value: userModel?.data?.phoneNumber ?? "");
        if (kDebugMode) {
         
        }
       _appPreferences.getFirstName(key: "firstName").then((value){
         Constants.firstName = value!;
       });
        _appPreferences.getLastName(key: "lastName").then((value){
          Constants.lastName = value!;
        });

        _appPreferences.getPhoneNumber(key: "phoneNumber").then((value){
          Constants.phoneNumber = value!;
        });
        if (kDebugMode) {
         
        }
        emit(GetUserSuccessState());
      }).catchError((error) {
        if (kDebugMode) {
         
        }
        emit(GetUserErrorState(error.toString()));
      });
    } else {
      showNoInternetMessage();
    }
  }

  void showImprovedDialog(BuildContext context) {
    if (Platform.isIOS) {
      _showCupertinoDialog(context);
    } else {
      _showMaterialDialog(context);
    }
  }

  void _showMaterialDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            AppStrings.confirmation.tr(),
            style: getSemiBoldStyle(
              color: ColorManager.primary,
              fontSize: FontSize.s18.sp,
            ),
          ),
          content: Text(
            AppStrings.logOutMessage.tr(),
            style: getMediumStyle(
              color: ColorManager.black,
              fontSize: FontSize.s16.sp,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                AppStrings.cancel.tr(),
                style: getMediumStyle(
                  color: ColorManager.lightPrimary,
                  fontSize: FontSize.s14.sp,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.error,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                AppStrings.logout.tr(),
                style: getSemiBoldStyle(
                  color: Colors.white,
                  fontSize: FontSize.s14.sp,
                ),
              ),
              onPressed: () => _handleLogout(context),
            ),
          ],
        );
      },
    );
  }

  void _showCupertinoDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            AppStrings.confirmation.tr(),
            style: getSemiBoldStyle(
              color: ColorManager.primary,
              fontSize: FontSize.s18.sp,
            ),
          ),
          content: Text(
            AppStrings.logOutMessage.tr(),
            style: getMediumStyle(
              color: ColorManager.black,
              fontSize: FontSize.s16.sp,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                AppStrings.cancel.tr(),
                style: getMediumStyle(
                  color: ColorManager.lightPrimary,
                  fontSize: FontSize.s14.sp,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text(
                AppStrings.logout.tr(),
                style: getSemiBoldStyle(
                  color: ColorManager.error,
                  fontSize: FontSize.s14.sp,
                ),
              ),
              onPressed: () => _handleLogout(context),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginView()),
      (route) => false,
    );
    _appPreferences.deleteUserLogin();
    _appPreferences.setToken(key: 'token', value: '');
    _appPreferences.setUserId(key: 'userId', value: '');
  }
}
