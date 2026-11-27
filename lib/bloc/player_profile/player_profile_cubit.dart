import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coachmax_coach/dto/player_profile_response_dto.dart';
import 'package:coachmax_coach/network/rest_client.dart';
import 'package:dio/dio.dart';
import 'package:coachmax_coach/utils/constants.dart';
import 'package:coachmax_coach/utils/shared_prefs_helper.dart';
import 'package:coachmax_coach/network/logging_interceptor.dart';
import 'player_profile_state.dart';

class PlayerProfileCubit extends Cubit<PlayerProfileState> {
  PlayerProfileCubit() : super(PlayerProfileInitial());

  void fetchPlayerProfile(String playerId) async {
    emit(PlayerProfileLoading());
    try {
      final token = await SharedPrefsHelper.getToken() ?? '';

      final dio = Dio();
      dio.interceptors.add(LoggingInterceptor());
      final client = RestClient(dio);

      final response = await client.getPlayerProfileApi(
        Constants.baseurl,
        "Bearer $token",
        playerId,
      );

      final notesResponse = await client.getNotesApi(
        Constants.baseurl,
        "Bearer $token",
        playerId,
        1,
        100, // Fetch up to 100 notes
      );

      final body = response.data;
      if (body.success == true && body.data != null) {
        emit(PlayerProfileLoaded(body.data!, notes: notesResponse.data.data));
      } else {
        emit(
          PlayerProfileError(body.message ?? "Failed to load player profile"),
        );
      }
    } catch (e) {
      emit(PlayerProfileError(e.toString()));
    }
  }

  Future<void> addNote(
    String classId,
    String playerId,
    String noteType,
    String description, {
    bool isPersonal = false,
  }) async {
    try {
      final token = await SharedPrefsHelper.getToken();
      final authHeader = token != null ? "Bearer $token" : "";

      final dio = Dio();
      dio.interceptors.add(LoggingInterceptor());
      final restClient = RestClient(dio, baseUrl: Constants.baseurl);

      final body = {
        "playerId": playerId,
        "classId": classId,
        "noteType": noteType,
        "description": description,
        "isPersonal": isPersonal,
      };

      final response = await restClient.addNoteApi(
        Constants.baseurl,
        authHeader,
        body,
      );

      if (response.data.success == true) {
        print("Note added successfully");
        // Re-fetch to update profile timeline
        fetchPlayerProfile(playerId);
      }
    } catch (e) {
      print("Error adding note: $e");
    }
  }

  Future<void> sendDirectMessage(String parentId, String text) async {
    try {
      final token = await SharedPrefsHelper.getToken() ?? '';
      final authHeader = token != "" ? "Bearer $token" : "";

      final dio = Dio();
      dio.interceptors.add(LoggingInterceptor());
      final restClient = RestClient(dio, baseUrl: Constants.baseurl);

      final body = <String, dynamic>{"parentId": parentId};
      if (text.isNotEmpty) {
        body["text"] = text;
      }

      final response = await restClient.directMessage(
        Constants.baseurl,
        authHeader,
        body,
      );

      String? actualRoomId;
      if (response.data != null && response.data is Map) {
        final data = response.data['data'];
        if (data != null && data is Map) {
          if (data['room'] != null) {
            final room = data['room'];
            if (room is Map && room['_id'] != null) {
              actualRoomId = room['_id'].toString();
            } else {
              actualRoomId = room.toString();
            }
          } else if (data['_id'] != null) {
            actualRoomId = data['_id'].toString();
          }
        } else if (response.data['room'] != null) {
          final room = response.data['room'];
          if (room is Map && room['_id'] != null) {
            actualRoomId = room['_id'].toString();
          } else {
            actualRoomId = room.toString();
          }
        } else if (response.data['_id'] != null) {
          actualRoomId = response.data['_id'].toString();
        }
      }

      if (actualRoomId != null) {
        emit(PlayerProfileDirectMessageSuccess(actualRoomId));
      } else {
        emit(PlayerProfileDirectMessageError("Room ID not found in response"));
      }
    } catch (e) {
      emit(PlayerProfileDirectMessageError(e.toString()));
    }
  }
}
