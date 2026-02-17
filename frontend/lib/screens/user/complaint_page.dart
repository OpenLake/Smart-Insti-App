import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/provider/complaint_provider.dart';
import '../../components/borderless_button.dart';
import '../../provider/auth_provider.dart';
import 'package:smart_insti_app/models/complaint.dart';

class ComplaintPage extends ConsumerStatefulWidget {
  const ComplaintPage({super.key});

  @override
  ConsumerState<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends ConsumerState<ComplaintPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(complaintProvider.notifier).loadComplaints();
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Resolved':
        return UltimateTheme.accent;
      case 'Rejected':
        return Colors.redAccent;
      case 'In Progress':
        return UltimateTheme.primary;
      default:
        return UltimateTheme.textSub;
    }
  }

  @override
  Widget build(BuildContext context) {
    final complaintState = ref.watch(complaintProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddComplaintDialog(context, ref),
        backgroundColor: UltimateTheme.primary,
        icon: const Icon(Icons.rate_review_rounded, color: Colors.white),
        label: Text("New Record", style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, color: Colors.white)),
      ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack),
      body: complaintState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : complaintState.complaints.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_turned_in_rounded, size: 64, color: UltimateTheme.textSub.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Text("Clear as a bell! No complaints.", style: GoogleFonts.inter(color: UltimateTheme.textSub)),
                    ],
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final complaint = complaintState.complaints[index];
                            return _buildComplaintCard(complaint, index);
                          },
                          childCount: complaintState.complaints.length,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildComplaintCard(Complaint complaint, int index) {
    final statusColor = _getStatusColor(complaint.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: UltimateTheme.primary.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10)),
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
                  color: UltimateTheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  complaint.category.toUpperCase(),
                  style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.bold, color: UltimateTheme.primary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  complaint.status,
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            complaint.title,
            style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold, color: UltimateTheme.textMain),
          ),
          const SizedBox(height: 8),
          Text(
            complaint.description,
            style: GoogleFonts.inter(color: UltimateTheme.textSub, height: 1.5, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("SUBMITTED BY", style: GoogleFonts.spaceGrotesk(fontSize: 9, fontWeight: FontWeight.bold, color: UltimateTheme.textSub, letterSpacing: 1)),
                  Text(complaint.createdByName ?? 'Anonymous', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: UltimateTheme.textMain)),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: UltimateTheme.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_up_rounded, color: UltimateTheme.primary),
                      onPressed: () => ref.read(complaintProvider.notifier).upvoteComplaint(complaint.id),
                      visualDensity: VisualDensity.compact,
                    ),
                    Text(
                      "${complaint.upvotes.length}",
                      style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, color: UltimateTheme.primary),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ],
          ),
        ],
      ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1),
    );
  }

  void _showAddComplaintDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        title: Text('New Complaint', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialTextFormField(
                controller: ref.read(complaintProvider.notifier).titleController,
                hintText: 'What\'s the issue?',
              ),
              const SizedBox(height: 16),
              MaterialTextFormField(
                controller: ref.read(complaintProvider.notifier).descriptionController,
                hintText: 'Provide details...',
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: "Other",
                items: ["Mess", "Hostel Infrastructure", "Academic", "Other"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.inter(fontSize: 14))))
                    .toList(),
                onChanged: (val) {
                  if (val != null) ref.read(complaintProvider.notifier).updateCategory(val);
                },
                decoration: InputDecoration(
                  labelText: "Category",
                  labelStyle: GoogleFonts.inter(color: UltimateTheme.textSub),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        actions: [
          BorderlessButton(
            onPressed: () => context.pop(),
            label: const Text('Cancel'),
            backgroundColor: UltimateTheme.textSub.withOpacity(0.05),
            splashColor: UltimateTheme.textSub,
          ),
          BorderlessButton(
            onPressed: () {
              ref.read(complaintProvider.notifier).addComplaint();
              context.pop();
            },
            label: const Text('Submit'),
            backgroundColor: UltimateTheme.primary.withOpacity(0.1),
            splashColor: UltimateTheme.primary,
          ),
        ],
      ),
    );
  }
}
