import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../services/chat/chat_service.dart';
import '../../services/auth/auth_service.dart';
import '../../theme/ultimate_theme.dart';
import 'private_chat_screen.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  List<dynamic> _conversations = [];
  bool _isLoading = true;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final credentials = await ref.read(authServiceProvider).checkCredentials();
    _currentUserId = credentials['_id'];
    
    await _fetchConversations();
  }

  Future<void> _fetchConversations() async {
    final chatService = ref.read(chatServiceProvider);
    final conversations = await chatService.getConversations();
    if (mounted) {
      setState(() {
        _conversations = conversations;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Messages", style: GoogleFonts.outfit(color: UltimateTheme.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _conversations.isEmpty
              ? Center(child: Text("No conversations yet", style: GoogleFonts.outfit(color: Colors.grey)))
              : ListView.builder(
                  itemCount: _conversations.length,
                  itemBuilder: (context, index) {
                    final conversation = _conversations[index];
                    final participants = conversation['participants'] as List;
                    
                    // Find the other participant
                    final otherUser = participants.firstWhere(
                      (p) => p['_id'] != _currentUserId,
                      orElse: () => participants.first, // Fallback
                    );
                    
                    final lastMessage = conversation['lastMessage'];
                    final lastMessageContent = lastMessage != null ? lastMessage['content'] : "No messages yet";
                    final lastMessageTime = lastMessage != null ? DateTime.parse(lastMessage['createdAt']) : null;

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: UltimateTheme.primaryColor.withOpacity(0.1),
                        backgroundImage: otherUser['profilePicURI'] != null && otherUser['profilePicURI'].isNotEmpty
                            ? NetworkImage(otherUser['profilePicURI'])
                            : null,
                        child: otherUser['profilePicURI'] == null || otherUser['profilePicURI'].isEmpty
                            ? Text(otherUser['name'][0].toUpperCase(), style: const TextStyle(color: UltimateTheme.primaryColor))
                            : null,
                      ),
                      title: Text(otherUser['name'], style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        lastMessageContent, 
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(color: Colors.grey[600]),
                      ),
                      trailing: lastMessageTime != null 
                          ? Text(timeago.format(lastMessageTime), style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)) 
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PrivateChatScreen(
                              conversationId: conversation['_id'],
                              targetUserId: otherUser['_id'],
                              targetUserName: otherUser['name'],
                              targetUserProfilePic: otherUser['profilePicURI'],
                            ),
                          ),
                        ).then((_) => _fetchConversations()); // Refresh on return
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           // Navigate to a "New Chat" screen where users can search for others
           // For now, maybe just show a snackbar or TODO
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("New Chat Search unimplemented")));
        },
        backgroundColor: UltimateTheme.primaryColor,
        child: const Icon(Icons.add_comment, color: Colors.white),
      ),
    );
  }
}
