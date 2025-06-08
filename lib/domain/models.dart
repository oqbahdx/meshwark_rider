
class Rider {
  int? id;
  String? firstName;
  String? middleName;

  String? lastName;
  String? phone;

  Rider(this.id, this.firstName, this.middleName, this.lastName, this.phone);
}

class Authentication {
  Rider? rider;

  Authentication(this.rider);
}

class CurrentUser {
  int id;
  String firstName;
  String middleName;
  String lastName;
  String phone;
  String image;

  CurrentUser(this.id, this.firstName, this.middleName, this.lastName,
      this.phone, this.image);
}

class UserData {
  CurrentUser currentUser;

  UserData(this.currentUser);
}

class AllDrivers {
  String id;
  String firstName;
  String middleName;
  String lastName;
  String gender;
  String carModel;
  String image;
  String carColor;
  String available;
  int seatsAvailable;
  int seatsReserved;
  String service;
  String plateNumber;
  String nextDestination;
  double latitude;
  double longitude;

  AllDrivers(
      this.id,
      this.firstName,
      this.middleName,
      this.lastName,
      this.gender,
      this.carModel,
      this.image,
      this.carColor,
      this.available,
      this.seatsAvailable,
      this.seatsReserved,
      this.service,
      this.plateNumber,
      this.nextDestination,
      this.latitude,
      this.longitude);
}

class DriverData {
  List<AllDrivers> allDrivers;

  DriverData(this.allDrivers);
}

class DriverObject {
  DriverData data;

  DriverObject(this.data);
}

class AllNotifications {
  String id;
  String message;
  String day;
  String month;
  String time;

  AllNotifications(this.id, this.month, this.time, this.day, this.message);
}

class NotificationData {
  List<AllNotifications> allNotifications;

  NotificationData(this.allNotifications);
}

class NotificationObject {
  NotificationData data;

  NotificationObject(this.data);
}

class AllTripHistory {

  int userId;
  int tripId;
   String day;
  String time;

  String month;
  String startPoint;
  String endPoint;

  AllTripHistory(this.userId, this.tripId, this.day, this.time, this.month,
      this.startPoint, this.endPoint);
}

class TripHistory {
  List<AllTripHistory> tripHistory;

  TripHistory(this.tripHistory);
}

class TripHistoryData {
  TripHistory? data;

  TripHistoryData(this.data);
}



class PushNotification {
  String? title;
  String? body;
  String? titleData;
  String? bodyData;
  PushNotification({this.title, this.body, this.titleData, this.bodyData});
}
