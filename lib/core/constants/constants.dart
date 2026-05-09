class ApiConstants {
  static const String baseUrl = 'https://api.meshwark.com';
  static const int apiTimeOut = 30000;
  static const String loginEndPoint = '/api/Auth/login';
  static const String registerEndPoint = '/api/Auth/register';
  static const String profileEndPoint = '/api/Profile';
  static const String tripHistoryEndPoint = '/api/Trip/history';
  static const String walletEndPoint = '/api/Wallet';
  static const String notificationEndPoint = '/api/Notification';
  static const String servicesEndPoint = '/api/Services';
  static const String ratingEndPoint = '/api/Rating';
  static const String forgotPasswordEndPoint = '/api/Auth/forgot-password';
  static const String verifyCodeEndPoint = '/api/Auth/verify-code';
  static const String resetPasswordEndPoint = '/api/Auth/reset-password';
  static const String updateProfileEndPoint = '/api/Profile/update';
  static const String addProfileEndPoint = '/api/Profile/add';
  static const String logoutEndPoint = '/api/Auth/logout';
}

class AppConstants {
  static String token = '';
  static String id = '';
  static int isBoarding = 0;
  static String firstName = '';
  static String lastName = '';
  static const String appName = 'Meshwark Rider';
  static const String appVersion = '1.0.0';
}
