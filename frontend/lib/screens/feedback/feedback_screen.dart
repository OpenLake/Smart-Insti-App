import 'package:flutter/material.dart' hide Feedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_insti_app/components/borderless_button.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import '../../models/feedback.dart';
import '../../provider/feedback_provider.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(feedbackProvider.notifier).loadFeedbacks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedbackState = ref.watch(feedbackProvider);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: FloatingActionButton.extended(
            onPressed: () => _showAddComplaintDialog(context, ref),
            label: Text("Add Feedback",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            icon: const Icon(Icons.add_rounded),
            backgroundColor: UltimateTheme.primary,
            foregroundColor: Colors.white,
          ).animate().scale(delay: 500.ms, curve: Curves.easeOutBack),
        ),
        body: Column(
          children: [
            TabBar(
              isScrollable: true,
              indicatorColor: UltimateTheme.primary,
              labelColor: UltimateTheme.primary,
              unselectedLabelColor: UltimateTheme.textSub,
              tabs: const [
                Tab(text: "All"),
                Tab(text: "Complaints"),
                Tab(text: "Suggestions"),
                Tab(text: "Appreciations"),
                Tab(text: "Other"),
              ],
            ),
            Expanded(
              child: feedbackState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      children: [
                        _buildFeedbackList(feedbackState.feedbacks),
                        _buildFeedbackList(feedbackState.feedbacks
                            .where((f) => f.type == 'Complaint')
                            .toList()),
                        _buildFeedbackList(feedbackState.feedbacks
                            .where((f) => f.type == 'Suggestion')
                            .toList()),
                        _buildFeedbackList(feedbackState.feedbacks
                            .where((f) =>
                                f.type == 'Appreciation' ||
                                f.type == 'Feedback')
                            .toList()),
                        _buildFeedbackList(feedbackState.feedbacks
                            .where((f) => ![
                                  'Complaint',
                                  'Suggestion',
                                  'Appreciation',
                                  'Feedback'
                                ].contains(f.type))
                            .toList()),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackList(List<Feedback> feedbacks) {
    if (feedbacks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.feedback_outlined,
                size: 64, color: UltimateTheme.textSub.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text("No feedback found",
                style: GoogleFonts.inter(color: UltimateTheme.textSub)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      itemCount: feedbacks.length,
      itemBuilder: (context, index) {
        final feedback = feedbacks[index];
        return _buildFeedbackCard(feedback, index);
      },
    );
  }

  Widget _buildFeedbackCard(Feedback feedback, int index) {
    String targetName = 'General';
    if (feedback.targetData != null) {
      targetName = feedback.targetData?['name'] ??
          feedback.targetData?['title'] ??
          feedback.targetType;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: UltimateTheme.textSub.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          _getTypeColor(feedback.type).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      feedback.type.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _getTypeColor(feedback.type),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "to $targetName",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: UltimateTheme.textSub,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Text(
                DateFormat('MMM dd').format(feedback.createdAt),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: UltimateTheme.textSub,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            feedback.comments,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: UltimateTheme.textMain,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (feedback.rating > 0 && feedback.type != 'Complaint') ...[
                    const Icon(Icons.star_rounded,
                        color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      feedback.rating.toString(),
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                  if (feedback.isAnonymous) ...[
                    if (feedback.rating > 0 && feedback.type != 'Complaint')
                      const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Anonymous",
                        style: GoogleFonts.inter(
                            fontSize: 10, color: Colors.grey.shade600),
                      ),
                    ),
                  ] else if (feedback.feedbackByName != null) ...[
                    if (feedback.rating > 0 && feedback.type != 'Complaint')
                      const SizedBox(width: 12),
                    Text(
                      "by ${feedback.feedbackByName}",
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: UltimateTheme.textSub,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              ),
              if (feedback.isResolved)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: Colors.green, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        "Resolved",
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (feedback.actionsTaken != null &&
              feedback.actionsTaken!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: UltimateTheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Resolution:",
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: UltimateTheme.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feedback.actionsTaken!,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: UltimateTheme.textMain),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (index * 50).ms)
        .slideY(begin: 0.1, curve: Curves.easeOutQuad);
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Complaint':
        return Colors.red;
      case 'Suggestion':
        return Colors.blue;
      case 'Appreciation':
        return Colors.green;
      case 'Feedback':
        return Colors.orange;
      default:
        return UltimateTheme.accent;
    }
  }

  void _showAddComplaintDialog(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(feedbackProvider.notifier);
    notifier.resetForm();

    // Load targets when dialog opens
    notifier.loadTargets();

    final feedbackTypes = ['Complaint', 'Suggestion', 'Appreciation', 'Report'];
    final targetTypes = ['User', 'Event', 'Club/Organization', 'POR'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        final targetState = ref.watch(feedbackProvider);
        final targets =
            targetState.getTargetsForType(notifier.selectedTargetType);

        return AlertDialog(
          title: Text("Submit Feedback",
              style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Feedback Type ──
                Text("Type",
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: UltimateTheme.textSub)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: notifier.selectedType,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  items: feedbackTypes
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => notifier.setType(val));
                    }
                  },
                ),
                const SizedBox(height: 16),

                // ── Target Type ──
                Text("Target Type",
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: UltimateTheme.textSub)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: notifier.selectedTargetType,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  items: targetTypes
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => notifier.setTargetType(val));
                    }
                  },
                ),
                const SizedBox(height: 16),

                // ── Target Entity ──
                Text("Target",
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: UltimateTheme.textSub)),
                const SizedBox(height: 8),
                if (targetState.isLoadingTargets)
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  ))
                else if (targets.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      "No targets available for this type. Try a different target type.",
                      style: GoogleFonts.inter(
                          fontSize: 12, color: Colors.orange.shade700),
                    ),
                  )
                else
                  DropdownButtonFormField<String>(
                    value: notifier.selectedTargetId,
                    decoration: InputDecoration(
                      hintText: "Select a target...",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    isExpanded: true,
                    items: targets.map((target) {
                      final id = target['_id']?.toString() ?? '';
                      final displayName = FeedbackState.getTargetDisplayName(
                          notifier.selectedTargetType, target);
                      return DropdownMenuItem(
                          value: id,
                          child: Text(displayName,
                              overflow: TextOverflow.ellipsis));
                    }).toList(),
                    onChanged: (val) {
                      setState(() => notifier.setTargetId(val));
                    },
                  ),
                const SizedBox(height: 16),

                // ── Star Rating (hidden for Complaints) ──
                if (notifier.selectedType != 'Complaint') ...[
                  Text("Rating",
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: UltimateTheme.textSub)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      final starIndex = i + 1;
                      return GestureDetector(
                        onTap: () {
                          setState(
                              () => notifier.setRating(starIndex.toDouble()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            starIndex <= notifier.selectedRating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: Colors.amber,
                            size: 36,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Description ──
                Text("Comments",
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: UltimateTheme.textSub)),
                const SizedBox(height: 8),
                MaterialTextFormField(
                  controller: notifier.descriptionController,
                  hintText: "Your feedback...",
                  maxLines: 4,
                ),
                const SizedBox(height: 16),

                // ── Anonymous Toggle ──
                Row(
                  children: [
                    Switch(
                      value: notifier.isAnonymous,
                      activeColor: UltimateTheme.primary,
                      onChanged: (val) {
                        setState(() => notifier.setAnonymous(val));
                      },
                    ),
                    const SizedBox(width: 8),
                    Text("Submit Anonymously", style: GoogleFonts.inter()),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            BorderlessButton(
              onPressed: () => context.pop(),
              label: const Text('Cancel'),
              backgroundColor: Colors.red.shade50,
              splashColor: Colors.red.shade100,
            ),
            BorderlessButton(
              onPressed: () async {
                if (notifier.descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Comments cannot be empty")));
                  return;
                }
                if (notifier.selectedTargetId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a target")));
                  return;
                }

                final success = await notifier.submitFeedback();
                if (success) {
                  if (context.mounted) {
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Feedback submitted successfully!")));
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Failed to submit feedback")));
                  }
                }
              },
              label: const Text('Submit'),
              backgroundColor: UltimateTheme.primary.withValues(alpha: 0.1),
              splashColor: UltimateTheme.primary.withValues(alpha: 0.2),
            ),
          ],
        );
      }),
    );
  }
}
