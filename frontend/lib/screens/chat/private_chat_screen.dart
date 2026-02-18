import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../services/chat/chat_service.dart';
import '../../theme/ultimate_theme.dart';
import '../../services/auth/auth_service.dart';

class PrivateChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final String targetUserId;
  final String targetUserName;
  final String? targetUserProfilePic;

  const PrivateChatScreen({
    super.key,
    required this.conversationId,
    required this.targetUserId,
    required this.targetUserName,
    this.targetUserProfilePic,
  });

  @override
  ConsumerState<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends ConsumerState<PrivateChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _messages = [];
  bool _isLoading = true;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    final credentials = await ref.read(authServiceProvider).checkCredentials();
    _currentUserId = credentials['_id'];

    if (mounted) {
      await _fetchMessages();
      _listenToSocket();
    }
  }

  void _listenToSocket() {
    final chatService = ref.read(chatServiceProvider);
    chatService.messageStream.listen((data) {
      if (data['conversationId'] == widget.conversationId) {
        setState(() {
          _messages.add(data['message']);
        });
        _scrollToBottom();
      }
    });
  }

  Future<void> _fetchMessages() async {
    final chatService = ref.read(chatServiceProvider);
    final messages = await chatService.getMessages(widget.conversationId);
    if (mounted) {
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final content = _messageController.text.trim();
    _messageController.clear();
    
    // Optimistic UI update
    // We need a temporary ID or just add it to list
    // Ideally service returns standard message object

    final chatService = ref.read(chatServiceProvider);
    final newMessage = await chatService.sendMessage(widget.conversationId, content);

    if (newMessage != null && mounted) {
      setState(() {
        _messages.add(newMessage);
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.targetUserProfilePic != null 
                  ? NetworkImage(widget.targetUserProfilePic!) 
                  : null,
              child: widget.targetUserProfilePic == null 
                  ? Text(widget.targetUserName[0].toUpperCase())
                  : null,
            ),
            const SizedBox(width: 10),
            Text(widget.targetUserName, style: GoogleFonts.outfit(color: UltimateTheme.textColor)),
          ],
        ),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 1,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isMe = msg['sender']['_id'] == _currentUserId || msg['sender'] == _currentUserId;
                      
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isMe ? UltimateTheme.primaryColor : const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                              bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg['content'],
                                style: GoogleFonts.outfit(
                                  color: isMe ? Colors.white : Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                timeago.format(DateTime.parse(msg['createdAt'])),
                                style: GoogleFonts.outfit(
                                  color: isMe ? Colors.white70 : Colors.black54,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(8), // Add safe area padding if needed
            decoration: BoxDecoration(
              color: UltimateTheme.surfaceColor,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))
              ],
            ),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.attach_file), onPressed: () {}),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: UltimateTheme.backgroundColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: UltimateTheme.primaryColor),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
