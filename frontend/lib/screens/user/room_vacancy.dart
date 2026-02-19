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

class RoomVacancy extends ConsumerStatefulWidget {
  const RoomVacancy({super.key});

  @override
  ConsumerState<RoomVacancy> createState() => _RoomVacancyState();
}

class _RoomVacancyState extends ConsumerState<RoomVacancy> {
  final TextEditingController _searchController = TextEditingController();
  String _filter = 'All'; // 'All', 'Vacant', 'Occupied'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authProvider.notifier).tokenCheckProgress != LoadingState.progress) {
        ref.read(authProvider.notifier).verifyAuthTokenExistence(context, AuthConstants.generalAuthLabel.toLowerCase());
      }
    });

    final roomState = ref.watch(roomProvider);
    if (roomState.loadingState == LoadingState.progress) ref.read(roomProvider.notifier).loadRooms();

    // Filtering Logic
    List<Room> filteredRooms = [];
    if (roomState.loadingState == LoadingState.success) {
      filteredRooms = roomState.roomList.where((room) {
        final matchesSearch = room.name.toLowerCase().contains(_searchController.text.toLowerCase());
        final matchesFilter = _filter == 'All'
            ? true
            : _filter == 'Vacant'
                ? room.vacant
                : !room.vacant;
        return matchesSearch && matchesFilter;
      }).toList();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: roomState.loadingState == LoadingState.success
          ? CustomScrollView(
              slivers: [
                // 1. Header with Search and Filter
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Room Availability",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: UltimateTheme.textMain,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Search Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: UltimateTheme.primary.withOpacity(0.1)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (_) => setState(() {}),
                            style: GoogleFonts.inter(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "Search room...",
                              hintStyle: GoogleFonts.inter(color: UltimateTheme.textSub),
                              border: InputBorder.none,
                              icon: const Icon(Icons.search_rounded, color: UltimateTheme.primary),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_rounded, size: 20),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {});
                                      },
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Filter Chips
                        Row(
                          children: [
                            _buildFilterChip("All"),
                            const SizedBox(width: 8),
                            _buildFilterChip("Vacant"),
                            const SizedBox(width: 8),
                            _buildFilterChip("Occupied"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Room List
                filteredRooms.isNotEmpty
                    ? SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final room = filteredRooms[index];
                              return _buildRoomTile(context, room, ref, index);
                            },
                            childCount: filteredRooms.length,
                          ),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off_rounded, size: 64, color: UltimateTheme.textSub.withOpacity(0.5)),
                                const SizedBox(height: 16),
                                Text("No matching rooms found", style: GoogleFonts.inter(color: UltimateTheme.textSub)),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildFilterChip(String label) {
    final bool isSelected = _filter == label;
    return InkWell(
      onTap: () => setState(() => _filter = label),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? UltimateTheme.primary : UltimateTheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? UltimateTheme.primary : UltimateTheme.primary.withOpacity(0.1),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : UltimateTheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildRoomTile(BuildContext context, Room room, WidgetRef ref, int index) {
    final bool isVacant = room.vacant;
    final Color statusColor = isVacant ? UltimateTheme.accent : UltimateTheme.primary;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.12), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.meeting_room_rounded, color: statusColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              room.name,
              style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: UltimateTheme.textMain,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isVacant ? "VACANT" : "OCCUPIED",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 30).ms).slideX(begin: 0.05, curve: Curves.easeOutQuad);
  }
}

