import 'package:coachmax_coach/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coachmax_coach/bloc/class_details/class_details_state.dart';
import 'package:coachmax_coach/network/rest_client.dart';
import 'package:dio/dio.dart';
import 'package:coachmax_coach/network/logging_interceptor.dart';
import 'package:coachmax_coach/utils/shared_prefs_helper.dart';

class ClassDetailsCubit extends Cubit<ClassDetailsState> {
  ClassDetailsCubit() : super(ClassDetailsInitial());

  final String _baseUrl = Constants.baseurl;

  Future<void> fetchClassDetails(String classId) async {
    emit(ClassDetailsLoading());
    try {
      final token = await SharedPrefsHelper.getToken();
      final authHeader = token != null ? "Bearer $token" : "";

      final dio = Dio();
      dio.interceptors.add(LoggingInterceptor());
      final restClient = RestClient(dio, baseUrl: _baseUrl);

      final response = await restClient.getClassDetailsApi(
        _baseUrl,
        classId,
        authHeader,
      );

      final body = response.data;
      if (body.success == true && body.data != null) {
        emit(ClassDetailsLoaded(body.data!));
      } else {
        emit(ClassDetailsError(body.message ?? "Failed to load class details"));
      }
    } catch (e) {
      emit(ClassDetailsError("An error occurred: $e"));
    }
  }

  Future<void> markSingleAttendance(String classId, String playerId, String status, {String comment = "", String? sessionDate}) async {
    try {
      final token = await SharedPrefsHelper.getToken();
      final authHeader = token != null ? "Bearer $token" : "";
      
      final dio = Dio();
      dio.interceptors.add(LoggingInterceptor());
      final restClient = RestClient(dio, baseUrl: _baseUrl);

      final dateToUse = sessionDate ?? DateTime.now().toIso8601String().split('T')[0]; // Format yyyy-MM-dd
      
      final body = {
        "sessionDate": dateToUse,
        "playerId": playerId,
        "status": status,
        "comment": comment
      };

      final response = await restClient.markSingleAttendanceApi(
        _baseUrl,
        authHeader,
        classId,
        body
      );

      if (response.data.success == true) {
        // Re-fetch to update the UI
        fetchClassDetails(classId);
      }
    } catch (e) {
      print("Error marking single attendance: $e");
    }
  }

  Future<void> markAllAttendance(String classId, List<String> playerIds, {String? sessionDate}) async {
    try {
      final token = await SharedPrefsHelper.getToken();
      final authHeader = token != null ? "Bearer $token" : "";
      
      final dio = Dio();
      dio.interceptors.add(LoggingInterceptor());
      final restClient = RestClient(dio, baseUrl: _baseUrl);

      final dateToUse = sessionDate ?? DateTime.now().toIso8601String().split('T')[0];
      
      final records = playerIds.map((id) => {
        "player": id,
        "status": "PRESENT",
        "comment": "On time"
      }).toList();

      final body = {
        "sessionDate": dateToUse,
        "records": records
      };

      final response = await restClient.markAllAttendanceApi(
        _baseUrl,
        authHeader,
        classId,
        body
      );

      if (response.data.success == true) {
        // Re-fetch to update the UI
        fetchClassDetails(classId);
      }
    } catch (e) {
      print("Error marking all attendance: $e");
    }
  }

  Future<void> addNote(String classId, String playerId, String noteType, String description, {bool isPersonal = false}) async {
    try {
      final token = await SharedPrefsHelper.getToken();
      final authHeader = token != null ? "Bearer $token" : "";
      
      final dio = Dio();
      dio.interceptors.add(LoggingInterceptor());
      final restClient = RestClient(dio, baseUrl: _baseUrl);

      final body = {
        "playerId": playerId,
        "classId": classId,
        "noteType": noteType,
        "description": description,
        "isPersonal": isPersonal
      };

      final response = await restClient.addNoteApi(
        _baseUrl,
        authHeader,
        body
      );

      if (response.data.success == true) {
        print("Note added successfully");
      }
    } catch (e) {
      print("Error adding note: $e");
    }
  }
}
