import 'package:coachmax_coach/dto/my_profile_response_dto.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileDataDto profile;

  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileUpdateLoading extends ProfileState {
  final ProfileDataDto currentProfile;

  ProfileUpdateLoading(this.currentProfile);
}

class ProfileUpdateSuccess extends ProfileState {
  final ProfileDataDto updatedProfile;

  ProfileUpdateSuccess(this.updatedProfile);
}

class ProfileUpdateError extends ProfileState {
  final String message;
  final ProfileDataDto currentProfile;

  ProfileUpdateError(this.message, this.currentProfile);
}
