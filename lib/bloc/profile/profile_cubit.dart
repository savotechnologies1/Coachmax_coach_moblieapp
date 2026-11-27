import 'dart:io';
import 'package:coachmax_coach/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coachmax_coach/bloc/profile/profile_state.dart';
import 'package:coachmax_coach/network/rest_client.dart';
import 'package:dio/dio.dart';
import 'package:coachmax_coach/network/logging_interceptor.dart';
import 'package:coachmax_coach/utils/shared_prefs_helper.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final String _baseUrl =Constants.baseurl;

  Future<void> fetchMyProfile() async {
    emit(ProfileLoading());
    try {
      final token = await SharedPrefsHelper.getToken();
      final authHeader = token != null ? "Bearer $token" : "";

      final dio = Dio();
      dio.interceptors.add(LoggingInterceptor());
      final restClient = RestClient(dio, baseUrl: _baseUrl);
      
      final response = await restClient.getMyProfileApi(
        _baseUrl,
        authHeader,
      );

      final body = response.data;
      if (body.success == true && body.data != null) {
        emit(ProfileLoaded(body.data!));
      } else {
        emit(ProfileError(body.message ?? "Failed to load profile"));
      }
    } catch (e) {
      emit(ProfileError("An error occurred: $e"));
    }
  }

  Future<void> updateProfile({
    String? fullName,
    String? phone,
    File? profileImage,
  }) async {
    final currentState = state;
    if (currentState is! ProfileLoaded && currentState is! ProfileUpdateError) {
      return;
    }
    
    final currentProfile = (currentState is ProfileLoaded) 
        ? currentState.profile 
        : (currentState as ProfileUpdateError).currentProfile;

    emit(ProfileUpdateLoading(currentProfile));
    
    try {
      final token = await SharedPrefsHelper.getToken();
      final authHeader = token != null ? "Bearer $token" : "";

      final dio = Dio();
      dio.interceptors.add(LoggingInterceptor());
      final restClient = RestClient(dio, baseUrl: _baseUrl);
      
      final response = await restClient.updateMyProfileApi(
        _baseUrl,
        authHeader,
        fullName,
        phone,
        profileImage,
      );

      final body = response.data;
      if (body.success == true) {
        // Fetch profile again to get the updated data
        await fetchMyProfile();
      } else {
        emit(ProfileUpdateError(body.message ?? "Failed to update profile", currentProfile));
      }
    } catch (e) {
      emit(ProfileUpdateError("An error occurred: $e", currentProfile));
    }
  }
}
