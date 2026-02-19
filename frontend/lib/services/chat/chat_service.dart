import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:logger/logger.dart';
import 'package:smart_insti_app/constants/constants.dart';

final chatServiceProvider = Provider<ChatService>((_) => ChatService());

class ChatService {
  late final Dio _client;
  late IO.Socket _socket;
  final _secureStorage = const FlutterSecureStorage();
  final Logger _logger = Logger();
  
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  ChatService() {
    _client = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        validateStatus: (status) => status! < 500,
      ),
    );

    // Add Auth Interceptor
    _client.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.read(key: 'token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<void> initSocket() async {
    final token = await _secureStorage.read(key: 'token');
    if (token == null) return;

    _socket = IO.io(AppConstants.apiBaseUrl, IO.OptionBuilder()
      .setTransports(['websocket'])
      .setAuth({'token': token})
      .enableForceNew()
      .build()
    );

    _socket.connect();
    
    _socket.onConnect((_) {
      _logger.i('Socket connected');
    });

    _socket.on('new_message', (data) {
      _logger.i('New message received: $data');
      _messageController.add(data);
    });

    _socket.onDisconnect((_) => _logger.i('Socket disconnected'));
  }

  void disconnectSocket() {
    _socket.disconnect();
  }

  // Get all conversations
  Future<List<dynamic>> getConversations() async {
    try {
      final response = await _client.get('/chat/conversations');
      if (response.statusCode == 200 && response.data['status'] == true) {
        return response.data['data'];
      }
      return [];
    } catch (e) {
      _logger.e("Error fetching conversations: $e");
      return [];
    }
  }

  // Start or get conversation with user
  Future<Map<String, dynamic>?> startConversation(String targetUserId) async {
    try {
      final response = await _client.post('/chat/conversations/$targetUserId');
      if (response.statusCode == 200 && response.data['status'] == true) {
        return response.data['data'];
      }
      return null;
    } catch (e) {
      _logger.e("Error starting conversation: $e");
      return null;
    }
  }

  // Get messages for conversation
  Future<List<dynamic>> getMessages(String conversationId) async {
    try {
      final response = await _client.get('/chat/conversations/$conversationId/messages');
      if (response.statusCode == 200 && response.data['status'] == true) {
        return response.data['data'];
      }
      return [];
    } catch (e) {
      _logger.e("Error fetching messages: $e");
      return [];
    }
  }

  // Send message
  Future<Map<String, dynamic>?> sendMessage(String conversationId, String content) async {
    try {
      final response = await _client.post(
        '/chat/conversations/$conversationId/messages',
        data: {'content': content},
      );
      if (response.statusCode == 201 && response.data['status'] == true) {
        return response.data['data'];
      }
      return null;
    } catch (e) {
      _logger.e("Error sending message: $e");
      return null;
    }
  }
}
