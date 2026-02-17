import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/chat_room_provider.dart';
import '../../components/material_textformfield.dart';
import '../../constants/constants.dart';
import '../../models/student.dart';
import '../../provider/auth_provider.dart';

class ChatRoom extends ConsumerWidget {
  const ChatRoom({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStudent = ref.watch(authProvider).currentUser as Student;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. Premium Chat Header
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 16, left: 8, right: 8),
            decoration: BoxDecoration(
              gradient: UltimateTheme.brandGradient,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
              boxShadow: [
                BoxShadow(color: UltimateTheme.primary.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 8),
                const CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.groups_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Common Room',
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Campus-wide discussion',
                        style: GoogleFonts.inter(fontSize: 11, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Chat Messages
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final messages = ref.watch(chatRoomProvider).messageList;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  controller: ref.read(chatRoomProvider.notifier).scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.sender == currentStudent.name;
                    return _buildMessageBubble(context, message, isMe, index);
                  },
                );
              },
            ),
          ),

          // 3. Message Input Area
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5)),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: UltimateTheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: UltimateTheme.primary.withOpacity(0.1)),
                    ),
                    child: MaterialTextFormField(
                      controller: ref.read(chatRoomProvider).messageController,
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    gradient: UltimateTheme.brandGradient,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    onPressed: () {
                      ref.read(chatRoomProvider.notifier).addMessage(currentStudent.name);
                      ref.read(chatRoomProvider.notifier).loadMessages();
                    },
                  ),
                ).animate().scale(delay: 200.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, message, bool isMe, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4),
              child: Text(
                message.sender,
                style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.bold, color: UltimateTheme.primary),
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isMe ? UltimateTheme.primary : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMe ? 20 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 20),
              ),
              border: isMe ? null : Border.all(color: UltimateTheme.primary.withOpacity(0.1)),
              boxShadow: isMe
                  ? [BoxShadow(color: UltimateTheme.primary.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))]
                  : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Text(
              message.content,
              style: GoogleFonts.inter(
                color: isMe ? Colors.white : UltimateTheme.textMain,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ).animate().fadeIn(delay: (index * 20).ms).slideX(begin: isMe ? 0.1 : -0.1),
          const SizedBox(height: 4),
          Text(
            '${message.timestamp!.toLocal().toString().split(' ')[1].substring(0, 5)}',
            style: GoogleFonts.inter(fontSize: 9, color: UltimateTheme.textSub),
          ),
        ],
      ),
    );
  }
}
