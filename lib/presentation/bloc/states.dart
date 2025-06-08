abstract class AppStates {}

class AppInitialState extends AppStates {}

class UploadProfileImageState extends AppStates {}

class DeleteProfileImageState extends AppStates {}

class OtpLoadingState extends AppStates {}

class OtpSuccessState extends AppStates {}

class OtpErrorState extends AppStates {
  final String error;

  OtpErrorState(this.error);
}

class OtpVerifiedState extends AppStates {}

class GetCurrentUserLoadingState extends AppStates {}

class GetCurrentUserSuccessState extends AppStates {}

class GetCurrentUserErrorState extends AppStates {
  final String error;

  GetCurrentUserErrorState(this.error);
}

class UpdateCurrentUserLoadingState extends AppStates {}

class UpdateCurrentUserSuccessState extends AppStates {}

class UpdateCurrentUserErrorState extends AppStates {
  final String error;

  UpdateCurrentUserErrorState(this.error);
}




class AddProfileLoadingState extends AppStates{}
class AddProfileSuccessState extends AppStates{}
class AddProfileErrorState extends AppStates{
  final String error;

  AddProfileErrorState(this.error);
}


class GetNotificationLoadingState extends AppStates{}
class GetNotificationSuccessState extends AppStates{}
class GetNotificationErrorState extends AppStates{
  final String error;

  GetNotificationErrorState(this.error);
}







class ChangeRadioToManState extends AppStates{}
class ChangeRadioToWomanState extends AppStates{}

