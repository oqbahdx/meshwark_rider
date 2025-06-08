import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/resources/language_manager.dart';

const String prefsKeyLang = "prefsKeyLang";
const String prefsKeyOnBoarding = "prefsKeyOnBoarding";
const String prefsKeyIsLoggedIn = "prefsKeyIsLoggedIn";
const String prefsKeyAddProfile = "prefsKeyAddProfile";
const String prefsKeyIsOtpFinished = "prefsKeyIsOtpFinished";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(prefsKeyLang);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      // return default lang
      return LanguageType.ARABIC.getValue();
    }
  }

  Future<void> changeAppLanguage() async {
    String currentLang = await getAppLanguage();
    if (currentLang == LanguageType.ARABIC.getValue()) {
      _sharedPreferences.setString(
          prefsKeyLang, LanguageType.ENGLISH.getValue());
    } else {
      _sharedPreferences.setString(
          prefsKeyLang, LanguageType.ARABIC.getValue());
    }
  }

  Future<Locale> getLocale() async {
    String currentLang = await getAppLanguage();
    if (currentLang == LanguageType.ARABIC.getValue()) {
      return ARABIC_LOCALE;
    } else {
      return ENGLISH_LOCALE;
    }
  }

  // on boarding

  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(prefsKeyOnBoarding, true);
  }

  Future<bool> isOnBoardingScreenViewed() async {
    return _sharedPreferences.getBool(prefsKeyOnBoarding) ?? false;
  }

  //login

  Future<void> setUserLoggedIn() async {
    _sharedPreferences.setBool(prefsKeyIsLoggedIn, true);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(prefsKeyIsLoggedIn) ?? false;
  }

  Future<void> deleteUserLogin() async {
    _sharedPreferences.setBool(prefsKeyIsLoggedIn, false);
  }

  Future<void> setAddProfile() async {
    _sharedPreferences.setBool(prefsKeyAddProfile, true);
  }

  Future<bool> isProfileAdded() async {
    return _sharedPreferences.getBool(prefsKeyAddProfile) ?? false;
  }

  Future<void> setIsOtpFinished() async {
    _sharedPreferences.setBool(prefsKeyIsOtpFinished, true);
  }

  Future<bool> isOtpFinished() async {
    return _sharedPreferences.getBool(
          prefsKeyIsOtpFinished,
        ) ??
        false;
  }

  Future<void> setToken({required String key, required String value}) async {
    _sharedPreferences.setString(key, value);
  }

  Future<String?> getToken({required String key}) async {
    return _sharedPreferences.getString(key);
  }

  Future<String?> getUserId({required String key}) async {
    return _sharedPreferences.getString(key);
  }

  Future<void> setUserId({
    required var key,
    required String value,
  }) async {
    _sharedPreferences.setString(key, value);
  }

  Future<String?> getId({required String key}) async {
    return _sharedPreferences.getString(key);
  }

  Future<void> setId({
    required var key,
    required int value,
  }) async {
    _sharedPreferences.setInt(key, value);
  }

  Future<int?> getBoarding({required String key}) async {
    return _sharedPreferences.getInt(key);
  }

  Future<void> setBoarding({
    required var key,
    required int value,
  }) async {
    _sharedPreferences.setInt(key, value);
  }

  Future<String?> getPhoneNumber({required String key}) async {
    return _sharedPreferences.getString(key);
  }

  Future<void> setPhoneNumber({
    required var key,
    required String value,
  }) async {
    _sharedPreferences.setString(key, value);
  }
  Future<String?> getFirstName({required String key}) async {
    return _sharedPreferences.getString(key);
  }

  Future<void> setFirstName({
    required var key,
    required String value,
  }) async {
    _sharedPreferences.setString(key, value);
  }

  Future<String?> getMiddleName({required String key}) async {
    return _sharedPreferences.getString(key);
  }

  Future<void> setMiddleName({
    required var key,
    required String value,
  }) async {
    _sharedPreferences.setString(key, value);
  }

  Future<String?> getLastName({required String key}) async {
    return _sharedPreferences.getString(key);
  }

  Future<void> setLastName({
    required var key,
    required String value,
  }) async {
    _sharedPreferences.setString(key, value);
  }
}
