import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:coachmax_coach/dto/chat_dto.dart';
import 'package:coachmax_coach/network/rest_client.dart';
import 'package:coachmax_coach/utils/constants.dart';
import 'package:coachmax_coach/utils/shared_prefs_helper.dart';
import 'package:coachmax_coach/network/logging_interceptor.dart';
import 'package:coachmax_coach/network/socket_service.dart';
import '../api_resp_state.dart';

class ChatDetailState extends ResponseState {
  final List<ChatMessageDto> messages;
  final bool isTyping;
  final String? typingUserName;
  
  const ChatDetailState({
    required this.messages,
    this.isTyping = false,
    this.typingUserName,
  });

  @override
  List<Object> get props => [messages, isTyping, typingUserName ?? ''];

  ChatDetailState copyWith({
    List<ChatMessageDto>? messages,
    bool? isTyping,
    String? typingUserName,
  }) {
    return ChatDetailState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      typingUserName: typingUserName ?? this.typingUserName,
    );
  }
}

class ChatDetailCubit extends Cubit<ResponseState> {
  final String roomId;
  final SocketService _socketService = SocketService();
  StreamSubscription? _msgSub;
  StreamSubscription? _typeSub;
  StreamSubscription? _readSub;
  late RestClient _client;
  String? _token;
  String currentUserId = ""; // Set by UI if needed for matching sender

  ChatDetailCubit(this.roomId) : super(ResponseStateLoading()) {
    _initClient();
  }

  void _initClient() async {
    _token = await SharedPrefsHelper.getToken() ?? '';
    
    if (_token!.isNotEmpty) {
      try {
        final parts = _token!.split('.');
        if (parts.length == 3) {
          final payload = parts[1];
          final normalized = base64Url.normalize(payload);
          final resp = utf8.decode(base64Url.decode(normalized));
          final decoded = json.decode(resp);
          currentUserId = decoded['id']?.toString() ?? decoded['_id']?.toString() ?? decoded['sub']?.toString() ?? '';
        }
      } catch (e) {
        print("Error decoding token: $e");
      }
    }

    final dio = Dio();
    dio.interceptors.add(LoggingInterceptor());
    _client = RestClient(dio);
    
    _initSocket();
    fetchMessages();
  }

  void _initSocket() {
    _socketService.joinRoom(roomId);
    _socketService.markRead(roomId);

    _msgSub = _socketService.onReceiveMessage.listen((data) {
      if (data['roomId'] == roomId && state is ChatDetailState) {
        final st = state as ChatDetailState;
        final msgData = data['message'];
        if (msgData != null) {
          final msg = ChatMessageDto.fromJson(msgData);
          final newMessages = List<ChatMessageDto>.from(st.messages)..insert(0, msg);
          emit(st.copyWith(messages: newMessages));
          _socketService.markRead(roomId);
        }
      }
    });

    _typeSub = _socketService.onUserTyping.listen((data) {
      if (data['roomId'] == roomId && state is ChatDetailState) {
        final isTyping = data['isTyping'] == true;
        final userName = data['userName'];
        emit((state as ChatDetailState).copyWith(isTyping: isTyping, typingUserName: userName));
      }
    });

    _readSub = _socketService.onMessagesStatusChanged.listen((data) {
      if (data['roomId'] == roomId) {
        fetchMessages(silent: true);
      }
    });
  }

  @override
  Future<void> close() {
    _msgSub?.cancel();
    _typeSub?.cancel();
    _readSub?.cancel();
    return super.close();
  }

  void fetchMessages({bool silent = false}) async {
    if (!silent) {
      emit(ResponseStateLoading());
    }

    try {
      final response = await _client.getRoomMessagesApi(
        Constants.baseurl,
        "Bearer $_token",
        roomId,
      );
      
      final body = response.data;
      if (body.success == true && body.data != null) {
        // The list returned by API is oldest-first.
        // Reverse it so newest is at index 0 for ListView reverse: true.
        emit(ChatDetailState(
          messages: body.data!.reversed.toList(),
        ));
      } else {
        if (!silent) emit(const ResponseStateError("Failed to load messages"));
      }
    } catch (e) {
      if (!silent) emit(ResponseStateError(e.toString()));
    }
  }

  void sendMessage(String text) {
    if (text.isEmpty) return;
    
    _socketService.sendMessage(roomId, text, (result) {
      if (result != null && result['success'] == true) {
        fetchMessages(silent: true);
      } else {
        print("Socket send message failed, attempting REST fallback...");
        _sendRestFallback(text);
      }
    });
  }
  
  void _sendRestFallback(String text) async {
    try {
      final response = await _client.sendRestMessageFallbackApi(
        Constants.baseurl,
        "Bearer $_token",
        {
          "roomId": roomId,
          "text": text,
        }
      );
      if (response.data.success == true) {
         fetchMessages(silent: true);
      }
    } catch (e) {
      print("REST fallback failed: $e");
    }
  }

  void sendAttachment(File file, String fileType, [String text = ""]) async {
    try {
      final response = await _client.sendAttachmentMessageApi(
        Constants.baseurl,
        "Bearer $_token",
        roomId,
        text, 
        fileType, // IMAGE, VIDEO, or FILE
        file,
      );
      if (response.data.success == true) {
        fetchMessages(silent: true);
      }
    } catch (e) {
      print("Sending attachment failed: $e");
      emit(ResponseStateError("Failed to upload attachment: $e"));
    }
  }

  Timer? _typingTimer;
  void emitTyping() {
    _socketService.emitTyping(roomId, true);
    
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(milliseconds: 1500), () {
      _socketService.emitTyping(roomId, false);
    });
  }
}
