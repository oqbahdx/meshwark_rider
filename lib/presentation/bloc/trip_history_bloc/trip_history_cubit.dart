import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../app/constants.dart';
import '../../../data/network/dio_helper.dart';
import '../../../domain/trip_history_model.dart';
import '../../resources/Strings_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/value_manager.dart';

part 'trip_history_state.dart';

class TripHistoryCubit extends Cubit<TripHistoryState> {
  TripHistoryCubit() : super(TripHistoryInitial());
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
  }
    Future<bool> hasInternetAccess() async {
    try {
      final result = await http.get(Uri.parse('https://www.google.com')).timeout(const Duration(seconds: 3));
      return result.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

TripModel? tripModel;
List<TripModel>? trips;

void getTripHistory() async {
final connected = await hasInternetAccess();
  if (connected) {
    emit(TripHistoryLoadingState());
    try {
      final response = await DioHelper.getData(
          endPoint: '${Constants.tripsEndPoint}/${Constants.id}');
      if (response != null && response.statusCode == 200) {
        if (response.data['data'] is List) {
          final List<dynamic> tripJsonList = response.data['data'];
          trips = tripJsonList.map((json) => TripModel.fromJson(json as Map<String, dynamic>)).toList();
          emit(TripHistorySuccessState());
        } else {
          emit(TripHistoryErrorState('Unexpected response format'));
        }
        if (kDebugMode) {
         
        }
      } else {
        emit(TripHistoryErrorState('Failed to load trip history'));
      }
    } catch (error) {
      emit(TripHistoryErrorState(error.toString()));
      if (kDebugMode) {
       
      }
    }
  } else {
    showNoInternetMessage();
  }
}
}
