import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/constants.dart';
import '../../app/secure_token_storage.dart';

const String applicationJson = "application/json";
const String contentType = "content-type";
const String accept = "accept";
const String authorization = "authorization";
const String defaultLanguage = "language";

class DioHelper {
  static Dio? dio;

  static init() {
    Map<String, String> headers = {
      contentType: applicationJson,
      accept: applicationJson,
      defaultLanguage: "en"
    };
    dio = Dio(BaseOptions(
        baseUrl: Constants.baseUrl,
        headers: headers,
        receiveTimeout: const Duration(seconds: Constants.apiTimeOut),
        sendTimeout: const Duration(seconds: Constants.apiTimeOut)));
    dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final String? token = await SecureTokenStorage.readToken();
            if (token != null && token.isNotEmpty) {
              options.headers[authorization] = "Bearer $token";
            }
          } catch (_) {}
          return handler.next(options);
        },
      ),
    );
    if (!kReleaseMode) {
      // its debug mode so print app logs
      dio?.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }
  }

  static Future<Response?> getData(
      {required String endPoint, Map<String, dynamic>? query}) async {
    return await dio?.get(endPoint, queryParameters: query);
  }

  static Future<Response?> updateData(
      {required String endPoint, required Map<String, dynamic> data}) async {
    return await dio?.put(endPoint, data: data);
  }

  static Future<Response?> postData(
      {required String endPoint, required Map<String, dynamic> data}) async {
    return await dio?.post(endPoint, data: data);
  }

  static Future<Response?> postDataWithImage(
      {required String endPoint, required FormData data}) async {
    return await dio?.put(endPoint, data: data);
  }
  static Future<Response?> updateDataWithImage(
      {required String endPoint, required FormData data}) async {
    return await dio?.put(endPoint, data: data);
  }
}
