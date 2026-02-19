import 'package:flutter/material.dart' hide Feedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_insti_app/components/borderless_button.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
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
      ref.read(feedbackProvider.notifier).loadMyComplaints();
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedbackState = ref.watch(feedbackProvider);
    
    return Scaffold(
      backgroundColor: Colors.transparent, // Assumes background from parent/main scaffold
      appBar: AppBar(
        title: Text(
          "Complaints",
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.bold,
            color: UltimateTheme.textMain,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: UltimateTheme.textMain),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddComplaintDialog(context, ref),
        label: Text("Add Complaint", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_rounded),
        backgroundColor: UltimateTheme.primary,
        foregroundColor: Colors.white,
      ).animate().scale(delay: 500.ms, curve: Curves.easeOutBack),
      body: feedbackState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : feedbackState.feedbacks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.thumb_down_off_alt_rounded, size: 64, color: UltimateTheme.textSub.withOpacity(0.3)),
                      const SizedBox(height: 16),
                      Text("No complaints found", style: GoogleFonts.inter(color: UltimateTheme.textSub)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: feedbackState.feedbacks.length,
                  itemBuilder: (context, index) {
                    final feedback = feedbackState.feedbacks[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: UltimateTheme.textSub.withOpacity(0.1)),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: UltimateTheme.accent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  feedback.targetType,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: UltimateTheme.accent,
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat('MMM dd, yyyy').format(feedback.createdAt),
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
                              fontSize: 15,
                              color: UltimateTheme.textMain,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              if (feedback.isAnonymous)
                                Chip(
                                  label: Text("Anonymous", style: GoogleFonts.inter(fontSize: 10)),
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                  backgroundColor: Colors.grey.withOpacity(0.1),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1, curve: Curves.easeOutQuad);
                  },
                ),
    );
  }

  void _showAddComplaintDialog(BuildContext context, WidgetRef ref) {
    // Reset state potentially
    ref.read(feedbackProvider.notifier).categoryController.clear();
    
    // Categories
    final categories = ["Mess", "Hostel", "Academic", "Infrastructure", "Other"];
    String selectedCategory = categories.first;
    ref.read(feedbackProvider.notifier).setCategory(selectedCategory);

    bool isAnonymous = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("New Complaint", style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Category", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: UltimateTheme.textSub)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => selectedCategory = val);
                        ref.read(feedbackProvider.notifier).setCategory(val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  Text("Description", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: UltimateTheme.textSub)),
                  const SizedBox(height: 8),
                  MaterialTextFormField(
                    controller: ref.read(feedbackProvider.notifier).descriptionController,
                    hintText: "Describe your issue...",
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Switch(
                        value: isAnonymous,
                        activeColor: UltimateTheme.primary,
                        onChanged: (val) {
                          setState(() => isAnonymous = val);
                          ref.read(feedbackProvider.notifier).setAnonymous(val);
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
                  if (ref.read(feedbackProvider.notifier).descriptionController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Description cannot be empty")));
                    return;
                  }
                  
                  final success = await ref.read(feedbackProvider.notifier).addComplaint();
                  if (success) {
                    if (context.mounted) {
                       context.pop();
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Complaint submitted successfully")));
                    }
                  } else {
                     if (context.mounted) {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to submit complaint")));
                     }
                  }
                },
                label: const Text('Submit'),
                backgroundColor: UltimateTheme.primary.withOpacity(0.1),
                splashColor: UltimateTheme.primary.withOpacity(0.2),
              ),
            ],
          );
        }
      ),
    );
  }
}
