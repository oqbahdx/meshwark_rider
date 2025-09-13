import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../app/constants.dart';
import '../../../data/network/dio_helper.dart';
import '../../../domain/notification_model.dart';
import '../../resources/Strings_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());
  FToast fToast = FToast();
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

    // Custom Toast Position
    // fToast.showToast(
    //     child: toast,
    //     toastDuration: const Duration(seconds: 2),
    //     positionedToastBuilder: (context, child) {
    //       return Positioned(
    //         top: 16.0,
    //         left: 16.0,
    //         child: child,
    //       );
    //     });
  }
  Future<bool> hasInternetAccess() async {
    try {
      final result = await http.get(Uri.parse('https://www.google.com')).timeout(const Duration(seconds: 3));
      return result.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
  NotificationModel? notificationModel;
  List<NotificationModel>? notifications;

  Future<void> getNotification() async {
    final connected = await hasInternetAccess();
    if (connected) {
      emit(GetNotificationsLoadingState());
    
      try {
        final response = await DioHelper.getData(
            endPoint: '${Constants.notificationEndPoint}/${Constants.id}');
        if (response != null && response.statusCode == 200) {
          final List<dynamic> notificationJsonList = response.data;
          notifications = notificationJsonList
              .map((json) => NotificationModel.fromJson(json))
              .toList();
          emit(GetNotificationsSuccessState());
        } else {
          emit(GetNotificationsErrorState('Failed to load notifications'));
        }
      } catch (error) {
        emit(GetNotificationsErrorState(error.toString()));
        if (kDebugMode) {
         
        }
      }
    } else {
      showNoInternetMessage();
    }
  }

  Future<void> getNotificationWithRefreshIndicator() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      DioHelper.getData(
              endPoint: '${Constants.notificationEndPoint}/${Constants.id}')
          .then((value) {
        notificationModel = NotificationModel.fromJson(value?.data);
        emit(GetNotificationsSuccessState());
        if (kDebugMode) {
         
        }
      }).catchError((error) {
        emit(GetNotificationsErrorState(error.toString()));
        if (kDebugMode) {
         
        }
      });
    } else {
      showNoInternetMessage();
    }
  }
}
