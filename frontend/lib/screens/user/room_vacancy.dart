import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/components/borderless_button.dart';
import 'package:smart_insti_app/constants/constants.dart';
import 'package:smart_insti_app/provider/room_provider.dart';
import '../../models/admin.dart';
import '../../models/faculty.dart';
import '../../models/room.dart';
import '../../models/student.dart';
import '../../provider/auth_provider.dart';

class RoomVacancy extends ConsumerWidget {
  const RoomVacancy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authProvider.notifier).tokenCheckProgress != LoadingState.progress) {
        ref.read(authProvider.notifier).verifyAuthTokenExistence(context, AuthConstants.generalAuthLabel.toLowerCase());
      }
    });
    final roomState = ref.watch(roomProvider);
    if (roomState.loadingState == LoadingState.progress) ref.read(roomProvider.notifier).loadRooms();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: roomState.loadingState == LoadingState.success
          ? roomState.roomList.isNotEmpty
              ? CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.9,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final room = roomState.roomList[index];
                            return _buildRoomCard(context, room, ref, index);
                          },
                          childCount: roomState.roomList.length,
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.door_back_door_outlined, size: 64, color: UltimateTheme.textSub.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Text("No rooms found", style: GoogleFonts.inter(color: UltimateTheme.textSub)),
                    ],
                  ),
                )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildRoomCard(BuildContext context, Room room, WidgetRef ref, int index) {
    final bool isVacant = room.vacant;
    final Color statusColor = isVacant ? UltimateTheme.accent : UltimateTheme.primary;
    
    return InkWell(
      onTap: () => _showRoomDetails(context, room, ref),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: statusColor.withOpacity(0.12), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.meeting_room_rounded, color: statusColor, size: 24),
            ),
            const Spacer(),
            Text(
              room.name,
              style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: UltimateTheme.textMain,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: statusColor.withOpacity(0.4), blurRadius: 4),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isVacant ? "VACANT" : "OCCUPIED",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutQuad);
  }

  void _showRoomDetails(BuildContext context, Room room, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text(room.name, style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              room.vacant ? 'This room is currently vacant.' : 'This room is occupied by ${room.occupantName}.',
              style: GoogleFonts.inter(color: UltimateTheme.textMain),
            ),
          ],
        ),
        actions: [
          if (room.vacant)
            BorderlessButton(
              onPressed: () {
                ref.read(roomProvider.notifier).reserveRoom(room);
                context.pop();
              },
              label: const Text('Reserve'),
              backgroundColor: UltimateTheme.primary.withOpacity(0.1),
              splashColor: UltimateTheme.primary,
            )
          else
            Consumer(
              builder: (_, ref, __) {
                final authState = ref.watch(authProvider);
                String? userId;
                if (authState.currentUserRole == 'student') userId = (authState.currentUser as Student).id;
                else if (authState.currentUserRole == 'faculty') userId = (authState.currentUser as Faculty).id;
                else if (authState.currentUserRole == 'admin') userId = (authState.currentUser as Admin).id;

                if (userId == room.occupantId) {
                  return BorderlessButton(
                    onPressed: () {
                      ref.read(roomProvider.notifier).vacateRoom(room);
                      context.pop();
                    },
                    label: const Text('Vacate'),
                    backgroundColor: Colors.red.withOpacity(0.1),
                    splashColor: Colors.red,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          BorderlessButton(
            onPressed: () => context.pop(),
            label: const Text('Close'),
            backgroundColor: UltimateTheme.textSub.withOpacity(0.1),
            splashColor: UltimateTheme.textSub,
          ),
        ],
      ),
    );
  }
}
