import 'package:coachmax_coach/utils/constants.dart';
import 'package:coachmax_coach/dto/classes_response_dto.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coachmax_coach/bloc/home/home_state.dart';
import 'package:coachmax_coach/network/rest_client.dart';
import 'package:dio/dio.dart';
import 'package:coachmax_coach/network/logging_interceptor.dart';
import 'package:coachmax_coach/utils/shared_prefs_helper.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final String _baseUrl = Constants.baseurl;

  int _currentPage = 1;
  bool _isFetching = false;
  bool _hasReachedMax = false;
  final int _limit = 20;
  List<ClassDataDto> _allClasses = [];

  // Filter params
  String? _termId;
  String? _day;
  String? _filterType;
  String? _date;
  String? _dayOfWeek;
  String? _weekDate;
  String? _startDate;
  String? _endDate;

  Future<void> fetchClasses({
    int page = 1,
    int limit = 20,
    String? termId,
    String? day,
    String? filterType,
    String? date,
    String? dayOfWeek,
    String? weekDate,
    String? startDate,
    String? endDate,
  }) async {
    _currentPage = 1;
    _hasReachedMax = false;
    _allClasses = [];
    _termId = termId;
    _day = day;
    _filterType = filterType;
    _date = date;
    _dayOfWeek = dayOfWeek;
    _weekDate = weekDate;
    _startDate = startDate;
    _endDate = endDate;

    emit(HomeLoading());
    await _fetchData();
  }

  Future<void> loadMoreClasses() async {
    if (_isFetching || _hasReachedMax) return;
    _currentPage++;
    emit(HomeLoaded(List.from(_allClasses), isLoadingMore: true, hasReachedMax: _hasReachedMax));
    await _fetchData();
  }

  Future<void> _fetchData() async {
    if (_isFetching) return;
    _isFetching = true;
    try {
      final token = await SharedPrefsHelper.getToken();
      final authHeader = token != null ? "Bearer $token" : "";

      final dio = Dio();
      dio.interceptors.add(LoggingInterceptor());
      final restClient = RestClient(dio, baseUrl: _baseUrl);
      
      String? currentTermId = _termId;

      if (currentTermId == null) {
        try {
          final int currentYear = DateTime.now().year;
          final termResponse = await restClient.getAllTermsApi(_baseUrl, authHeader, "all", currentYear);
          if (termResponse.data != null) {
            List<dynamic> termsList = [];
            if (termResponse.data is Map && termResponse.data['data'] != null) {
              termsList = termResponse.data['data'];
            } else if (termResponse.data is List) {
              termsList = termResponse.data;
            }
            
            if (termsList.isNotEmpty) {
               final now = DateTime.now();
               for (var t in termsList) {
                 final startDateStr = t['startDate'];
                 final endDateStr = t['endDate'];
                 if (startDateStr != null && endDateStr != null) {
                   try {
                     final start = DateTime.parse(startDateStr);
                     final end = DateTime.parse(endDateStr).add(const Duration(days: 1));
                     if (now.isAfter(start) && now.isBefore(end)) {
                       currentTermId = t['_id'];
                       break;
                     }
                   } catch (_) {}
                 }
               }
               // Fallback to first if none matches
               if (currentTermId == null && termsList.isNotEmpty) {
                 currentTermId = termsList.first['_id'];
               }
            }
          }
        } catch (e) {
          print("Failed to fetch terms: $e");
        }
      }

      String? currentDay = _day;
      if (_filterType == null && _date == null && _weekDate == null && _startDate == null) {
        currentDay ??= DateFormat('EEEE').format(DateTime.now());
      }

      final response = await restClient.getClassesApi(
        _baseUrl,
        _currentPage,
        _limit,
        authHeader,
        currentTermId,
        currentDay,
        _filterType,
        _date,
        _dayOfWeek,
        _weekDate,
        _startDate,
        _endDate,
      );

      final body = response.data;
      if (body.success == true && body.data != null) {
        if (body.data!.isEmpty || body.data!.length < _limit) {
          _hasReachedMax = true;
        }
        _allClasses.addAll(body.data!);
        emit(HomeLoaded(List.from(_allClasses), hasReachedMax: _hasReachedMax, isLoadingMore: false));
      } else {
        if (_allClasses.isEmpty) {
          emit(HomeError(body.message ?? "Failed to load classes"));
        } else {
          emit(HomeLoaded(List.from(_allClasses), hasReachedMax: _hasReachedMax, isLoadingMore: false));
        }
      }
    } catch (e) {
      if (_allClasses.isEmpty) {
        emit(HomeError("An error occurred: $e"));
      } else {
        emit(HomeLoaded(List.from(_allClasses), hasReachedMax: _hasReachedMax, isLoadingMore: false));
      }
    } finally {
      _isFetching = false;
    }
  }

  Future<void> broadcastMessage(String classId, String chatRoomId, String text, String chatName) async {
    emit(HomeBroadcastLoading());
    try {
      final token = await SharedPrefsHelper.getToken();
      final authHeader = token != null ? "Bearer $token" : "";

      final dio = Dio();
      dio.interceptors.add(LoggingInterceptor());
      final restClient = RestClient(dio, baseUrl: _baseUrl);

      final response = await restClient.broadcastMessage(
        _baseUrl,
        classId,
        authHeader,
        {"text": text, "chatRoomId": chatRoomId},
      );
      String actualRoomId = chatRoomId;
      if (response.data != null && response.data is Map) {
        final data = response.data['data'];
        if (data != null && data is Map && data['room'] != null) {
          final room = data['room'];
          if (room is Map && room['_id'] != null) {
            actualRoomId = room['_id'].toString();
          } else {
            actualRoomId = room.toString();
          }
        } else if (response.data['room'] != null) {
          final room = response.data['room'];
          if (room is Map && room['_id'] != null) {
            actualRoomId = room['_id'].toString();
          } else {
            actualRoomId = room.toString();
          }
        }
      }
      
      emit(HomeBroadcastSuccess("Broadcast sent successfully", actualRoomId, chatName));
      emit(HomeLoaded(List.from(_allClasses), hasReachedMax: _hasReachedMax));
    } catch (e) {
      String errorMsg = "Something went wrong";
      if (e is DioException) {
        if (e.response?.data != null && e.response?.data is Map) {
          if (e.response?.data['message'] != null) {
            errorMsg = e.response?.data['message'];
          } else {
            errorMsg = e.response?.statusMessage ?? errorMsg;
          }
        } else {
          errorMsg = e.message ?? errorMsg;
        }
      } else {
        errorMsg = e.toString();
      }
      emit(HomeBroadcastError(errorMsg));
      emit(HomeLoaded(List.from(_allClasses), hasReachedMax: _hasReachedMax));
    }
  }
}
