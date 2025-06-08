part of 'add_profile_cubit.dart';

@immutable
abstract class AddProfileState {}

class AddProfileInitial extends AddProfileState {}

class AddProfileLoadingState extends AddProfileState {}

class AddProfileSuccessState extends AddProfileState {}

class AddProfileErrorState extends AddProfileState {
  final String error;

  AddProfileErrorState(this.error);
}

class UploadImageState extends AddProfileState {}
class ChangeGenderState extends AddProfileState {}
