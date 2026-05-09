import 'package:meshwark_rider/core/constants/constants.dart';
import 'package:meshwark_rider/core/network/api_client.dart';
import 'package:meshwark_rider/features/profile/data/models/profile_models.dart';
import 'package:meshwark_rider/features/profile/domain/entities/profile_entities.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(ProfileUpdateParams params);
  Future<void> uploadImage(String imagePath);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ProfileModel> getProfile() async {
    final result = await apiClient.get(ApiConstants.profileEndPoint);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) => ProfileModel.fromJson(response.data['data']),
    );
  }

  @override
  Future<ProfileModel> updateProfile(ProfileUpdateParams params) async {
    final result =
        await apiClient.put(ApiConstants.updateProfileEndPoint, data: {
      if (params.firstName != null) 'firstName': params.firstName,
      if (params.lastName != null) 'lastName': params.lastName,
      if (params.gender != null) 'gender': params.gender,
      if (params.personalImage != null) 'personalImage': params.personalImage,
      if (params.carInfo != null) 'carInfo': params.carInfo?.toJson(),
    });
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) => ProfileModel.fromJson(response.data['data']),
    );
  }

  @override
  Future<void> uploadImage(String imagePath) async {
    await apiClient.post('${ApiConstants.profileEndPoint}/image',
        data: {'imagePath': imagePath});
  }
}
