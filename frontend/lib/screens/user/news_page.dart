import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/announcement_provider.dart';
import '../../components/borderless_button.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/announcement.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: AnnouncementListWidget(),
    );
  }
}

class AnnouncementListWidget extends ConsumerStatefulWidget {
  const AnnouncementListWidget({super.key});

  @override
  ConsumerState<AnnouncementListWidget> createState() =>
      _AnnouncementListWidgetState();
}

class _AnnouncementListWidgetState
    extends ConsumerState<AnnouncementListWidget> {
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

    final filterTypes = [
      'All',
      'General',
      'Organizational_Unit',
      'Course',
      'System'
    ];

    return Column(
      children: [
        // Filter Bar
        Container(
          height: 64,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: filterTypes.length,
            itemBuilder: (context, index) {
              final type = filterTypes[index];
              final isSelected = announcementState.selectedType == type;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FilterChip(
                  label: Text(type.replaceAll('_', ' ')),
                  selected: isSelected,
                  onSelected: (selected) {
                    ref.read(announcementProvider.notifier).updateFilter(type);
                  },
                  backgroundColor: Theme.of(context).cardTheme.color,
                  selectedColor: UltimateTheme.primary.withValues(alpha: 0.1),
                  checkmarkColor: UltimateTheme.primary,
                  labelStyle: GoogleFonts.inter(
                    color: isSelected
                        ? UltimateTheme.primary
                        : UltimateTheme.textSub,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 13,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected
                          ? UltimateTheme.primary
                          : UltimateTheme.primary.withValues(alpha: 0.1),
                      width: 1.5,
                    ),
                  ),
                ),
              );
            },
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
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color:
                                  UltimateTheme.primary.withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.campaign_outlined,
                                size: 64,
                                color: UltimateTheme.primary
                                    .withValues(alpha: 0.3)),
                          ),
                          const SizedBox(height: 24),
                          Text("No announcements found",
                              style: GoogleFonts.spaceGrotesk(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: UltimateTheme.textMain)),
                          Text("Be the first to share something important!",
                              style: GoogleFonts.inter(
                                  color: UltimateTheme.textSub)),
                        ],
                      ).animate().fadeIn(),
                    )
                  : RefreshIndicator(
                      onRefresh: () async => ref
                          .read(announcementProvider.notifier)
                          .loadAnnouncements(),
                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final announcement =
                                      announcementState.announcements[index];
                                  return _buildAnnouncementCard(
                                      announcement, index);
                                },
                                childCount:
                                    announcementState.announcements.length,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildAnnouncementCard(Announcement announcement, int index) {
    final bool isPinned = announcement.isPinned;
    final authorName = announcement.author['name'] ?? 'Unknown';
    final authorRole = announcement.author['roles'] != null
        ? (announcement.author['roles'] as List).first
        : 'User';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isPinned
              ? UltimateTheme.accent.withValues(alpha: 0.3)
              : UltimateTheme.primary.withValues(alpha: 0.05),
          width: isPinned ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPinned)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    UltimateTheme.accent.withValues(alpha: 0.2),
                    UltimateTheme.accent.withValues(alpha: 0.05)
                  ],
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.push_pin_rounded,
                      size: 14, color: UltimateTheme.accent),
                  const SizedBox(width: 8),
                  Text("PINNED ANNOUNCEMENT",
                      style: GoogleFonts.spaceGrotesk(
                        color: UltimateTheme.accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      )),
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
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: UltimateTheme.brandGradientSoft,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          authorName[0].toUpperCase(),
                          style: GoogleFonts.spaceGrotesk(
                            color: UltimateTheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                authorName,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: UltimateTheme.textMain),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: UltimateTheme.primary
                                      .withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(authorRole.toString().toUpperCase(),
                                    style: GoogleFonts.inter(
                                        fontSize: 9,
                                        color: UltimateTheme.primary,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.5)),
                              ),
                            ],
                          ),
                          Text(
                            timeago.format(announcement.createdAt),
                            style: GoogleFonts.inter(
                                color: UltimateTheme.textSub,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: UltimateTheme.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(announcement.type.replaceAll('_', ' '),
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              color: UltimateTheme.secondary,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  announcement.title,
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    height: 1.25,
                    color: UltimateTheme.textMain,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  announcement.content,
                  style: GoogleFonts.inter(
                    color: UltimateTheme.textMain.withValues(alpha: 0.7),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1);
  }
}

void showAddAnnouncementDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      title: Text('New Broadcast',
          style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.bold, fontSize: 24)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialTextFormField(
                controller:
                    ref.read(announcementProvider.notifier).titleController,
                hintText: 'Announcement Title',
                prefixIcon: const Icon(Icons.title_rounded),
              ),
              const SizedBox(height: 16),
              MaterialTextFormField(
                controller:
                    ref.read(announcementProvider.notifier).contentController,
                hintText: 'Content',
                maxLines: 5,
                prefixIcon: const Icon(Icons.description_outlined),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: "General",
                items: ['General', 'Organizational_Unit', 'Course', 'System']
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.replaceAll('_', ' '),
                            style: GoogleFonts.inter(
                                fontSize: 14, fontWeight: FontWeight.w500))))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    ref
                        .read(announcementProvider.notifier)
                        .newAnnouncementType = val;
                  }
                },
                icon: const Icon(Icons.arrow_drop_down_rounded,
                    color: UltimateTheme.primary),
                decoration: InputDecoration(
                  labelText: "Announcement Category",
                  labelStyle: GoogleFonts.inter(
                      color: UltimateTheme.textSub, fontSize: 14),
                  filled: true,
                  fillColor: UltimateTheme.primary.withValues(alpha: 0.05),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: UltimateTheme.primary.withValues(alpha: 0.1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: UltimateTheme.primary.withValues(alpha: 0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                        color: UltimateTheme.primary, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      actions: [
        Row(
          children: [
            Expanded(
              child: BorderlessButton(
                onPressed: () => context.pop(),
                label: const Text('Cancel'),
                backgroundColor: UltimateTheme.textSub.withValues(alpha: 0.05),
                splashColor: UltimateTheme.textSub,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BorderlessButton(
                onPressed: () {
                  ref.read(announcementProvider.notifier).addAnnouncement();
                  context.pop();
                },
                label: const Text('Post'),
                backgroundColor: UltimateTheme.primary.withValues(alpha: 0.1),
                splashColor: UltimateTheme.primary,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
