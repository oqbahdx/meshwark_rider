import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meshwark_rider/app/app_pref.dart';
import 'package:meshwark_rider/app/constants.dart';
import 'package:meshwark_rider/app/di.dart';
import 'package:meshwark_rider/data/network/dio_helper.dart';
import 'package:meshwark_rider/presentation/bloc/states.dart';
import 'package:meshwark_rider/presentation/resources/Strings_manager.dart';
import 'package:meshwark_rider/presentation/resources/color_manager.dart';
import 'package:meshwark_rider/presentation/resources/style_manager.dart';
import 'package:meshwark_rider/presentation/resources/value_manager.dart';
import 'package:rxdart/rxdart.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


import '../../domain/current_user_model.dart';
import '../../domain/notification_model.dart';
import '../../domain/place_suggestion_model.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  final AppPreferences _appPreferences = instance<AppPreferences>();

  static AppCubit get(context) => BlocProvider.of(context);
  final picker = ImagePicker();
  File? image;
  FToast fToast = FToast();

  Future getImage(ImageSource src) async {
    final pickedFile = await picker.pickImage(
        source: src, imageQuality: 80, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(UploadProfileImageState());
    }
    if (kDebugMode) {
    
    }
    emit(UploadProfileImageState());
  }

  void deleteProfileImage() {
    image = null;
    emit(DeleteProfileImageState());
  }

  late String verificationId;

  void codeSent(String verificationId, int? resendToken) {
    if (kDebugMode) {
   
    }
    this.verificationId = verificationId;
    emit(OtpSuccessState());
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    if (kDebugMode) {
     
    }
  }

  UserModel? userModel;

  void getUserData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      emit(GetCurrentUserLoadingState());
      DioHelper.getData(endPoint: "/rider-profile?user_id=${Constants.id}")
          .then((value) {
        userModel = UserModel.fromJson(value?.data);

        Timer(const Duration(milliseconds: 500), () {});
        Timer(const Duration(milliseconds: 600), () {
          _appPreferences.getId(key: 'id').then((value) {
            Constants.id = value!;
          });
        });
        Timer(const Duration(milliseconds: 700), () {
          if (kDebugMode) {
           
          }
          if (kDebugMode) {
           
          }
        });

        if (kDebugMode) {
         
        }
        if (kDebugMode) {}
        if (kDebugMode) {
         
        }
        emit(GetCurrentUserSuccessState());
      }).catchError((error) {
        if (kDebugMode) {
         
        }
        emit(GetCurrentUserErrorState(error.toString()));
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

  NotificationModel? notificationModel;
  List? newList;
  Future<void> getNotification() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      emit(GetNotificationLoadingState());
      DioHelper.getData(endPoint: '/notifications?user_id=${Constants.id}')
          .then((value) {
        notificationModel = NotificationModel.fromJson(value?.data);
        // newList = notificationModel?.data?.notifications?.length as List;
        emit(GetNotificationSuccessState());
        if (kDebugMode) {
        
        }
      }).catchError((error) {
        emit(GetNotificationErrorState(error.toString()));
        if (kDebugMode) {
         
        }
      });
    } else {
      showNoInternetMessage();
    }
  }

  Future<void> getNotificationWithRefreshIndicator() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      DioHelper.getData(endPoint: '/notifications?user_id=${Constants.id}')
          .then((value) {
        notificationModel = NotificationModel.fromJson(value?.data);
        emit(GetNotificationSuccessState());
        if (kDebugMode) {
        
        }
      }).catchError((error) {
        emit(GetNotificationErrorState(error.toString()));
        if (kDebugMode) {
         
        }
      });
    } else {
      showNoInternetMessage();
    }
  }

  var numberController = BehaviorSubject<String>();

  Stream<String> get nameStream => numberController.stream;

  updateName(String text) {
    if (text.length < 4) {
      numberController.sink.addError("Please enter your full name here");
    } else {
      numberController.sink.add(text);
    }
  }

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initializeNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/launcher_icon");
    DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );
    await _localNotificationService.initialize(settings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  NotificationDetails _notificationDetails() {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channel_id", "channel_name",
            channelDescription: "channelDescription",
            importance: Importance.max,
            priority: Priority.max,
            playSound: true);
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();

    return const NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
  }

  Future<void> showNotification({
    required dynamic id,
    required String title,
    required String body,
  }) async {
    final notificationDetails = _notificationDetails();
    await _localNotificationService.show(id, title, body, notificationDetails);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    if (kDebugMode) {
    
    }
  }

  void onDidReceiveNotificationResponse(NotificationResponse details) {
    if (kDebugMode) {
     
    }
  }

  String publicKey = "pk_sbox_kphzjesonz5ofslucb2pxvmzayl";
  String secretKey = "sk_sbox_bagh7iuewbqbe4yccyav3rnkmie";

  // todo : add configuration for ios checkout payment

  // CardTokenisationResponse?  cardTokenisationResponse;
  // Future<CardTokenisationResponse> generateToken(
  //     {required String number,
  //     required String name,
  //     required String expiryMonth,
  //     required String expiryYear,
  //     required String cvv,
  //     required BillingModel billingModel}) async {
  //   return cardTokenisationResponse = CardTokenisationResponse(type: ,name: ,cardType: ,expiryMonth: ,expiryYear: ,token: );
  // }

  Future<bool> isCardValid({required String number}) async {
    return true;
  }

  bool isManRadio = true;
  bool isWomanRadio = false;

  changeRadioToMan(dynamic value) {
    isManRadio = value!;
    emit(ChangeRadioToManState());
  }

  changeRadioToWoman(dynamic value) {
    isWomanRadio = value!;
    emit(ChangeRadioToWomanState());
  }

  PlaceSuggestionModel? placeSuggestionModel;

  Future<List<dynamic>> getSuggestion(
      {required String searchInput, required String sessiontoken}) async {
    DioHelper.getData(endPoint: Constants.suggestionUrl, query: {
      "input": searchInput,
      "type": "address",
      "components": "country:sa",
      "key": Constants.googleApiKey,
      "sessiontoken": sessiontoken
    }).then((value) {
      placeSuggestionModel =
          PlaceSuggestionModel.fromJson(value?.data['predictions']);
      if (kDebugMode) {
       
      }
    }).catchError((error) {
      if (kDebugMode) {
       
      }
    });
    return [];
  }
}
