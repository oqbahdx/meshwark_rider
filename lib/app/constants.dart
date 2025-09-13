class Constants {
static const String baseUrl = "http://meshwark.com/api/";
static const String hubUrl = "http://meshwark.com/";
    // static const String baseUrl = "https://192.168.1.109:5001/api/";
    //  static const String hubUrl = "https://192.168.1.109:5001/";
  //  static const String baseUrl = "https://10.0.2.2:5001/api/";
  //  static const String hubUrl = "https://10.0.2.2:5001/";

  static const String registerEndPoint = "/auth/register";
  static const String loginEndPoint = "/auth/login";
  static const String getUserEndPoint = "/users/";
  static const String updateUserEndPoint = "/users/update";
  static const String notificationEndPoint = "/notifications";
  static const String tripsEndPoint = "/trip";
  static const String getDriversEndPoint = "/Users/drivers";
  static const String sendPushNotificationEndPoint = "sendNotification/send";
  static const String sendRequestToDriverEndPoint =
      "RideRequest/sendTripRequest";
  static const String cancelRequestToDriverEndPoint = "RideRequest/cancelTrip";
  static const String googleApiKey = "AIzaSyDaehUmhV5GS62I-7BOVBe_wss0HI-2GJk";
  static const String suggestionUrl =
      "https://maps.googleapis.com/maps/api/place/autocomplete/json";
  static const String empty = "";
  static String firstName = "";
  static String middleName = "";
  static String lastName = "";
  static int isBoarding = 0;
  static String token = "";
  static String id = "";
  static String phoneNumber = "";
  static const int zero = 0;
  static const double doubleZero = 0.0;
  static const int apiTimeOut = 60000;
}
