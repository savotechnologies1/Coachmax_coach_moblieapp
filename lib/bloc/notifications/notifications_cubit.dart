import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:coachmax_coach/network/rest_client.dart';
import 'package:coachmax_coach/utils/constants.dart';
import 'package:coachmax_coach/utils/shared_prefs_helper.dart';
import 'package:coachmax_coach/network/logging_interceptor.dart';
import 'package:coachmax_coach/bloc/notifications/notifications_state.dart';
import 'package:coachmax_coach/dto/notification_dto.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  Future<void> fetchNotifications() async {
    emit(NotificationsLoading());
    try {
      final token = await SharedPrefsHelper.getToken();
      final authHeader = token != null ? "Bearer $token" : "";

      final dio = Dio();
      dio.interceptors.add(LoggingInterceptor());
      final restClient = RestClient(dio);

      final response = await restClient.getNotificationsApi(
        Constants.baseurl,
        authHeader,
      );

      final body = response.data;
      if (body.success == true && body.data != null) {
        emit(NotificationsLoaded(body.data!));
      } else {
        emit(NotificationsError(body.message ?? "Failed to fetch notifications"));
      }
    } catch (e) {
      emit(NotificationsError("An error occurred: $e"));
    }
  }

  Future<void> markAllAsRead() async {
    final currentState = state;
    if (currentState is! NotificationsLoaded) return;
    
    // Optimistic update
    final updatedNotifications = currentState.notifications.map((n) {
      return NotificationDto(
        id: n.id,
        title: n.title,
        description: n.description,
        type: n.type,
        createdAt: n.createdAt,
        isRead: true, // Mark as read
      );
    }).toList();
    emit(NotificationsLoaded(updatedNotifications));

    try {
      final token = await SharedPrefsHelper.getToken();
      final authHeader = token != null ? "Bearer $token" : "";

      final dio = Dio();
      dio.interceptors.add(LoggingInterceptor());
      final restClient = RestClient(dio);

      final response = await restClient.markAllNotificationsReadApi(
        Constants.baseurl,
        authHeader,
      );

      if (response.data.success != true) {
        // Revert on failure
        fetchNotifications();
      }
    } catch (e) {
      // Revert on failure
      fetchNotifications();
    }
  }
}
