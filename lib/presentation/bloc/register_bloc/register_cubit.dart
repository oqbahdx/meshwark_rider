import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meshwark_rider/domain/register_model.dart';

import '../../../app/app_pref.dart';
import '../../../app/constants.dart';
import '../../../app/di.dart';
import '../../../data/network/dio_helper.dart';
import '../../../domain/auth_model.dart';
import '../../resources/Strings_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  final AppPreferences _appPreferences = instance<AppPreferences>();
  FToast fToast = FToast();
  showErrorMessage({required String message, required BuildContext context}) {
    fToast.init(context);
    Widget toast = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.redAccent,
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
  showSuccessMessage({required String message, required BuildContext context}) {
    fToast.init(context);
    Widget toast = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: ColorManager.teal,
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
  bool isSecure = true;
  changePasswordVisible() {
    isSecure = !isSecure;
    emit(ChangePasswordVisibleState());
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

  AuthModel? authModel;
  RegisterModel? registerModel;
  void register(
      {required String number,
      required String email,
      required String password,
      required String fcmToken}) async {
    List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile)  ||
        connectivityResult.contains(ConnectivityResult.wifi) ) {
      emit(RegisterLoadingState());
      DioHelper.postData(endPoint: Constants.registerEndPoint, data: {
        "phoneNumber": number,
        "email": email,
        "password": password,
        "role": "Rider",
        "fcmToken": fcmToken
      }).then((value) {
        emit(RegisterSuccessState());
        if (kDebugMode) {
          print(value.toString());
          registerModel = RegisterModel.fromJson(value?.data);
        }
      }).catchError((error) {
        emit(RegisterErrorState(error.toString()));
        if (kDebugMode) {
          print(error.toString());
        }
      });
    } else {
      showNoInternetMessage();
    }
  }
}
