import 'dart:io';
import 'package:coachmax_coach/dto/utility_dto.dart';
import 'package:coachmax_coach/dto/classes_response_dto.dart';
import 'package:coachmax_coach/dto/my_profile_response_dto.dart';
import 'package:coachmax_coach/dto/player_profile_response_dto.dart';
import 'package:coachmax_coach/dto/chat_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:coachmax_coach/dto/notes_response_dto.dart';
import 'package:coachmax_coach/dto/temporary_player_dtos.dart';
import 'package:coachmax_coach/dto/notification_dto.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  static const header = [
    "Accept: application/json",
    "Content-Type: application/x-www-form-urlencoded",
  ];
  static const headerValue = "Accept: application/json";
  static const headerContentType =
      "Content-Type: application/x-www-form-urlencoded";
  static const authorization = "Authorization";
  // static const language = "Accept-Language : en";

  @POST("{url}api/v1/users/forgot-password")
  @Header(headerValue)
  // @FormUrlEncoded()
  Future<HttpResponse<UtilityDto>> forgotPasswordApi(
    @Path("url") url,
    @Body() body,
    @Header(authorization) token,
  );

  @POST("{url}api/admin/login")
  @Header(headerValue)
  Future<HttpResponse<UtilityDto>> loginApi(@Path("url") url, @Body() body);

  @GET("{url}api/coach/classes")
  @Header(headerValue)
  Future<HttpResponse<ClassesResponseDto>> getClassesApi(
    @Path("url") String url,
    @Query("page") int page,
    @Query("limit") int limit,
    @Header(authorization) String token,
    @Query("termId") String? termId,
    @Query("day") String? day,
    @Query("filterType") String? filterType,
    @Query("date") String? date,
    @Query("dayOfWeek") String? dayOfWeek,
    @Query("weekDate") String? weekDate,
    @Query("startDate") String? startDate,
    @Query("endDate") String? endDate,
  );

  @GET("{url}api/coach/classes/{id}")
  @Header(headerValue)
  Future<HttpResponse<ClassDetailsResponseDto>> getClassDetailsApi(
    @Path("url") String url,
    @Path("id") String id,
    @Header(authorization) String token,
  );

  @POST("{url}api/coach/chat/broadcast/{classId}")
  @Header(headerValue)
  Future<HttpResponse<dynamic>> broadcastMessage(
    @Path("url") String url,
    @Path("classId") String classId,
    @Header(authorization) String token,
    @Body() Map<String, dynamic> body,
  );

  @POST("{url}api/coach/chat/direct")
  @Header(headerValue)
  Future<HttpResponse<dynamic>> directMessage(
    @Path("url") String url,
    @Header(authorization) String token,
    @Body() Map<String, dynamic> body,
  );
  @GET("{url}api/auth/getMyProfile")
  @Header(headerValue)
  Future<HttpResponse<MyProfileResponseDto>> getMyProfileApi(
    @Path("url") String url,
    @Header(authorization) String token,
  );

  @PUT("{url}api/auth/updateMyProfile")
  @MultiPart()
  Future<HttpResponse<MyProfileResponseDto>> updateMyProfileApi(
    @Path("url") url,
    @Header(authorization) token,
    @Part(name: "fullName") String? fullName,
    @Part(name: "phone") String? phone,
    @Part(name: "profileImage") File? profileImage,
  );

  @GET("{url}api/coach/player/{id}")
  @Header(headerValue)
  Future<HttpResponse<PlayerProfileResponseDto>> getPlayerProfileApi(
    @Path("url") url,
    @Header(authorization) token,
    @Path("id") String id,
  );
  @GET("{url}api/coach/chat/rooms")
  @Header(headerValue)
  Future<HttpResponse<ChatListResponseDto>> getCoachChatRoomsApi(
    @Path("url") String url,
    @Header(authorization) String token, {
    @Query("type") String? type,
    @Query("search") String? search,
  });

  @GET("{url}api/coach/chat/class/{classId}/parents")
  @Header(headerValue)
  Future<HttpResponse<ClassParentsResponseDto>> getClassParentsApi(
    @Path("url") String url,
    @Header(authorization) String token,
    @Path("classId") String classId,
  );

  @POST("{url}api/coach/chat/direct")
  @Header(headerValue)
  Future<HttpResponse<CreateDirectChatResponseDto>> createDirectChatApi(
    @Path("url") String url,
    @Header(authorization) String token,
    @Body() Map<String, dynamic> body,
  );

  @GET("{url}api/coach/chat/room/{roomId}/messages")
  @Header(headerValue)
  Future<HttpResponse<ChatMessagesResponseDto>> getRoomMessagesApi(
    @Path("url") String url,
    @Header(authorization) String token,
    @Path("roomId") String roomId,
  );

  @POST("{url}api/coach/chat/message")
  @Header(headerValue)
  Future<HttpResponse<RestMessageFallbackResponseDto>>
  sendRestMessageFallbackApi(
    @Path("url") String url,
    @Header(authorization) String token,
    @Body() Map<String, dynamic> body,
  );

  @POST("{url}api/coach/chat/message")
  @MultiPart()
  Future<HttpResponse<RestMessageFallbackResponseDto>> sendAttachmentMessageApi(
    @Path("url") String url,
    @Header(authorization) String token,
    @Part(name: "roomId") String roomId,
    @Part(name: "text") String text,
    @Part(name: "fileType") String fileType,
    @Part(name: "file") File file,
  );
  @POST("{url}api/coach/attendance/{classId}/single")
  @Header(headerValue)
  Future<HttpResponse<UtilityDto>> markSingleAttendanceApi(
    @Path("url") String url,
    @Header(authorization) String token,
    @Path("classId") String classId,
    @Body() Map<String, dynamic> body,
  );

  @POST("{url}api/coach/attendance/{classId}")
  @Header(headerValue)
  Future<HttpResponse<UtilityDto>> markAllAttendanceApi(
    @Path("url") String url,
    @Header(authorization) String token,
    @Path("classId") String classId,
    @Body() Map<String, dynamic> body,
  );

  @POST("{url}api/coach/notes")
  @Header(headerValue)
  Future<HttpResponse<UtilityDto>> addNoteApi(
    @Path("url") String url,
    @Header(authorization) String token,
    @Body() Map<String, dynamic> body,
  );

  @GET("{url}api/coach/notes")
  @Header(headerValue)
  Future<HttpResponse<NotesResponseDto>> getNotesApi(
    @Path("url") String url,
    @Header(authorization) String token,
    @Query("playerId") String playerId,
    @Query("page") int page,
    @Query("limit") int limit,
  );

  @GET("{url}api/user/getCategories")
  @Header(headerValue)
  Future<HttpResponse<dynamic>> getCategoriesApi(
    @Path("url") String url,
    @Header(authorization) String token,
    @Query("isEvent") String isEvent,
  );

  @GET("{url}api/user/getProgramsByCategory/{categoryId}")
  @Header(headerValue)
  Future<HttpResponse<dynamic>> getProgramsByCategoryApi(
    @Path("url") String url,
    @Header(authorization) String token,
    @Path("categoryId") String categoryId,
  );

  @GET("{url}api/user/getAllTerms")
  @Header(headerValue)
  Future<HttpResponse<dynamic>> getAllTermsApi(
    @Path("url") String url,
    @Header(authorization) String token,
    @Query("isEvent") String isEvent,
    @Query("year") int? year,
  );

  @GET("{url}api/user/classes")
  @Header(headerValue)
  Future<HttpResponse<ClassDropdownResponseDto>> getDropdownClassesApi(
    @Path("url") String url,
    @Header(authorization) String token,
    @Query("category") String? category,
    @Query("program") String? program,
    @Query("term") String? term,
  );

  @POST("{url}api/coach/temporary-players")
  @Header(headerValue)
  Future<HttpResponse<UtilityDto>> addTemporaryPlayerApi(
    @Path("url") String url,
    @Header(authorization) String token,
    @Body() Map<String, dynamic> body,
  );

  @GET("{url}api/coach/temporary-players")
  @Header(headerValue)
  Future<HttpResponse<TemporaryPlayersListResponseDto>> getTemporaryPlayersApi(
    @Path("url") String url,
    @Header(authorization) String token,
  );

  @GET("{url}api/coach/notifications")
  @Header(headerValue)
  Future<HttpResponse<NotificationListResponseDto>> getNotificationsApi(
    @Path("url") String url,
    @Header(authorization) String token,
  );

  @PATCH("{url}api/coach/notifications/read-all")
  @Header(headerValue)
  Future<HttpResponse<UtilityDto>> markAllNotificationsReadApi(
    @Path("url") String url,
    @Header(authorization) String token,
  );
}
