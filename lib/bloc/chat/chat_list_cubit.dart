import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:coachmax_coach/dto/chat_dto.dart';
import 'package:coachmax_coach/network/rest_client.dart';
import 'package:coachmax_coach/utils/constants.dart';
import 'package:coachmax_coach/utils/shared_prefs_helper.dart';
import 'package:coachmax_coach/network/logging_interceptor.dart';
import 'package:coachmax_coach/network/socket_service.dart';
import '../api_resp_state.dart';

class ChatListCubit extends Cubit<ResponseState> {
  final SocketService _socketService = SocketService();
  StreamSubscription? _msgSub;
  StreamSubscription? _statusSub;
  
  ChatListCubit() : super(ResponseStateInitial());

  String? _currentType;
  String? _currentSearch;

  Future<void> fetchChats({String? type, String? search}) async {
    _currentType = type;
    _currentSearch = search;
    emit(ResponseStateLoading());
    try {
      final token = await SharedPrefsHelper.getToken() ?? '';
      
      _socketService.initSocket(token);
      _setupSocketListeners();
      
      final dio = Dio();
      dio.interceptors.add(LoggingInterceptor());
      final client = RestClient(dio);
      
      final response = await client.getCoachChatRoomsApi(
        Constants.baseurl,
        "Bearer $token",
        type: type,
        search: search,
      );
      
      final body = response.data;
      if (body.success == true && body.data != null) {
        if (body.data!.isEmpty) {
          emit(const ResponseStateEmpty("No chats found"));
        } else {
          emit(ResponseStateSuccess<List<ChatConversationDto>>(body.data!));
        }
      } else {
        emit(const ResponseStateError("Failed to fetch chats"));
      }
    } catch (e) {
      emit(ResponseStateError(e.toString()));
    }
  }

  void _setupSocketListeners() {
    _msgSub?.cancel();
    _statusSub?.cancel();
    
    _msgSub = _socketService.onReceiveMessage.listen((data) {
      _refreshChatsSilently();
    });
    
    _statusSub = _socketService.onUserStatusChange.listen((data) {
      _refreshChatsSilently();
    });
  }
  
  void _refreshChatsSilently() async {
    try {
      final token = await SharedPrefsHelper.getToken() ?? '';
      final dio = Dio();
      final client = RestClient(dio);
      
      final response = await client.getCoachChatRoomsApi(
        Constants.baseurl,
        "Bearer $token",
        type: _currentType,
        search: _currentSearch,
      );
      
      if (response.data.success == true && response.data.data != null) {
        emit(ResponseStateSuccess<List<ChatConversationDto>>(response.data.data!));
      }
    } catch (e) {
      // Ignore errors for silent background refresh
    }
  }

  @override
  Future<void> close() {
    _msgSub?.cancel();
    _statusSub?.cancel();
    return super.close();
  }
}
