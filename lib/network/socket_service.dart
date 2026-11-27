import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:coachmax_coach/utils/constants.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onReceiveMessage => _messageController.stream;

  final _typingController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onUserTyping => _typingController.stream;

  final _statusController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onUserStatusChange => _statusController.stream;

  final _readDeliveredController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onMessagesStatusChanged => _readDeliveredController.stream;

  final _broadcastAlertController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onNewBroadcastAlert => _broadcastAlertController.stream;

  void initSocket(String token) {
    if (_socket != null && _socket!.connected) return;

    String socketUrl = Constants.baseurl.endsWith('/') 
        ? Constants.baseurl.substring(0, Constants.baseurl.length - 1)
        : Constants.baseurl;

    _socket = IO.io(socketUrl, IO.OptionBuilder()
      .setTransports(['websocket'])
      .setAuth({'token': token})
      .enableAutoConnect()
      .build());

    _socket?.onConnect((_) {
      print('Socket Connected');
    });

    _socket?.on('new_message', (data) {
      if (data is Map) {
        _messageController.sink.add(Map<String, dynamic>.from(data));
      }
    });

    _socket?.on('user_typing', (data) {
      if (data is Map) {
        _typingController.sink.add(Map<String, dynamic>.from(data));
      }
    });

    _socket?.on('user_status_change', (data) {
      if (data is Map) {
        _statusController.sink.add(Map<String, dynamic>.from(data));
      }
    });

    _socket?.on('messages_read', (data) {
      if (data is Map) {
        _readDeliveredController.sink.add(Map<String, dynamic>.from(data));
      }
    });
    
    _socket?.on('message_delivered', (data) {
      if (data is Map) {
        _readDeliveredController.sink.add(Map<String, dynamic>.from(data));
      }
    });

    _socket?.on('new_broadcast_alert', (data) {
      if (data is Map) {
        _broadcastAlertController.sink.add(Map<String, dynamic>.from(data));
      }
    });

    _socket?.onDisconnect((_) => print('Socket Disconnected'));
  }

  void joinRoom(String roomId) {
    _socket?.emit('join_room', {'roomId': roomId});
  }

  void markRead(String roomId) {
    _socket?.emit('mark_read', {'roomId': roomId});
  }

  void sendMessage(String roomId, String text, [Function(dynamic)? ack]) {
    if (ack != null) {
      _socket?.emitWithAck('send_message', {'roomId': roomId, 'text': text}, ack: ack);
    } else {
      _socket?.emit('send_message', {'roomId': roomId, 'text': text});
    }
  }

  void emitTyping(String roomId, bool isTyping) {
    _socket?.emit('typing', {'roomId': roomId, 'isTyping': isTyping});
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}
