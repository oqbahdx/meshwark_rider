part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class ProfileUpdateLoadingState extends ProfileState {}
class ProfileUpdateSuccessState extends ProfileState {}
class ProfileUpdateErrorState extends ProfileState {
  final String error;

  ProfileUpdateErrorState(this.error);
}
class ProfileUploadImageState extends ProfileState{}
class ProfileDeleteImageState extends ProfileState{}