import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/announcement_provider.dart';
import '../../components/borderless_button.dart';
import '../../provider/auth_provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:smart_insti_app/models/student.dart';
import 'package:smart_insti_app/models/faculty.dart';
import 'package:smart_insti_app/models/admin.dart';
import 'package:smart_insti_app/models/alumni.dart';
import '../../models/announcement.dart';

class NewsPage extends ConsumerStatefulWidget {
  const NewsPage({super.key});

  @override
  ConsumerState<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends ConsumerState<NewsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(announcementProvider.notifier).loadAnnouncements();
    });
  }

  @override
  Widget build(BuildContext context) {
    final announcementState = ref.watch(announcementProvider);
    final currentUserRole = ref.watch(authProvider).currentUserRole;
    
    // Filter chips
    final filterTypes = ['All', 'General', 'Organizational_Unit', 'Course', 'System'];

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: currentUserRole == 'admin' || currentUserRole == 'faculty'
          ? FloatingActionButton(
              onPressed: () => _showAddAnnouncementDialog(context, ref),
              backgroundColor: UltimateTheme.primary,
              child: const Icon(Icons.add, color: Colors.white),
            ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack)
          : null,
      body: Column(
        children: [
          // Filter Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: filterTypes.map((type) {
                final isSelected = announcementState.selectedType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(type.replaceAll('_', ' ')),
                    selected: isSelected,
                    onSelected: (selected) {
                      ref.read(announcementProvider.notifier).updateFilter(type);
                    },
                    backgroundColor: Colors.white,
                    selectedColor: UltimateTheme.primary.withOpacity(0.1),
                    labelStyle: GoogleFonts.outfit(
                      color: isSelected ? UltimateTheme.primary : UltimateTheme.textSub,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? UltimateTheme.primary : Colors.transparent),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: announcementState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : announcementState.announcements.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.campaign_outlined, size: 64, color: UltimateTheme.textSub.withOpacity(0.5)),
                            const SizedBox(height: 16),
                            Text("No announcements found", style: GoogleFonts.inter(color: UltimateTheme.textSub)),
                          ],
                        ),
                      )
                    : CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final announcement = announcementState.announcements[index];
                                  return _buildAnnouncementCard(announcement, index);
                                },
                                childCount: announcementState.announcements.length,
                              ),
                            ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard(Announcement announcement, int index) {
    final bool isPinned = announcement.isPinned;
    final authorName = announcement.author['name'] ?? 'Unknown';
    final authorRole = announcement.author['roles'] != null ? (announcement.author['roles'] as List).first : 'User';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isPinned ? UltimateTheme.accent.withOpacity(0.5) : UltimateTheme.primary.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPinned)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              decoration: BoxDecoration(
                color: UltimateTheme.accent.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.push_pin, size: 12, color: UltimateTheme.accent),
                  const SizedBox(width: 4),
                  Text("Pinned Announcement", style: GoogleFonts.outfit(color: UltimateTheme.accent, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: UltimateTheme.primary.withOpacity(0.1),
                      child: Text(
                        authorName[0].toUpperCase(),
                        style: GoogleFonts.spaceGrotesk(
                          color: UltimateTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                authorName,
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(authorRole, style: GoogleFonts.inter(fontSize: 10, color: Colors.grey[800])),
                              ),
                            ],
                          ),
                          Text(
                            timeago.format(announcement.createdAt),
                            style: GoogleFonts.inter(color: UltimateTheme.textSub, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(announcement.type, style: GoogleFonts.inter(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  announcement.title,
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    height: 1.2,
                    color: UltimateTheme.textMain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  announcement.content,
                  style: GoogleFonts.inter(
                    color: UltimateTheme.textMain.withOpacity(0.8),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1, curve: Curves.easeOutQuad);
  }

  void _showAddAnnouncementDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Announcement'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialTextFormField(
                controller: ref.read(announcementProvider.notifier).titleController,
                hintText: 'Title',
              ),
              const SizedBox(height: 10),
              MaterialTextFormField(
                controller: ref.read(announcementProvider.notifier).contentController,
                hintText: 'Content',
                maxLines: 5,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: "General",
                items: ['General', 'Organizational_Unit', 'Course', 'System']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                   if(val != null) ref.read(announcementProvider.notifier).newAnnouncementType = val;
                },
                decoration: const InputDecoration(labelText: "Type", border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          BorderlessButton(
            onPressed: () => context.pop(),
            label: const Text('Cancel'),
            backgroundColor: Colors.red.shade100,
            splashColor: Colors.red.shade200,
          ),
          BorderlessButton(
            onPressed: () {
              ref.read(announcementProvider.notifier).addAnnouncement();
              context.pop();
            },
            label: const Text('Post'),
            backgroundColor: Colors.green.shade100,
            splashColor: Colors.green.shade200,
          ),
        ],
      ),
    );
  }
}
