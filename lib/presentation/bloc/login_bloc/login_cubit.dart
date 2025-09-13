import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../app/app_pref.dart';
import '../../../app/constants.dart';
import '../../../app/di.dart';
import '../../../data/network/dio_helper.dart';
import '../../../app/secure_token_storage.dart';
import '../../../domain/login_model.dart';
import '../../../domain/model/login_response_model.dart';
import '../../resources/Strings_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
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

    Future<bool> hasInternetAccess() async {
    try {
      final result = await http.get(Uri.parse('https://www.google.com')).timeout(const Duration(seconds: 3));
      return result.statusCode == 200;
    } catch (_) {
      return false;
    }
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

  LoginModel? loginModel; 
  LoginResponseModel? loginResponseModel;

  void login({required String phone, required String password}) async {
    final connected = await hasInternetAccess();
    if (connected == true) {
      emit(LoginLoadingState());
      try {
        final value = await DioHelper.postData(endPoint: Constants.loginEndPoint, data: {
          "phoneNumber": phone,
          "password": password,
        });
        loginModel = LoginModel.fromJson(value?.data);
        final String token = loginModel?.data?.token ?? "";
        await SecureTokenStorage.saveToken(token);
        await _appPreferences.setUserId(key: "userId", value: loginModel?.data?.id ?? "");
        final String? userId = await _appPreferences.getUserId(key: "userId");
        if (userId != null) {
          Constants.id = userId;
        }
        emit(LoginSuccessState());
        if (kDebugMode) {
        
        }
      } catch (error) {
        emit(LoginErrorState(error.toString()));
        if (kDebugMode) {
        
        }
      }
    } else {
      showNoInternetMessage();
    }
  }
}
