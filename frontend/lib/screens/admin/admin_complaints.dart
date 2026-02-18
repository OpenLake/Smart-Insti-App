import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../theme/ultimate_theme.dart';
import '../../provider/complaint_provider.dart';
import '../../models/complaint.dart';

class AdminComplaintScreen extends ConsumerStatefulWidget {
  const AdminComplaintScreen({super.key});

  @override
  ConsumerState<AdminComplaintScreen> createState() => _AdminComplaintScreenState();
}

class _AdminComplaintScreenState extends ConsumerState<AdminComplaintScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(complaintProvider.notifier).loadComplaints();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Complaint> _filterComplaints(List<Complaint> complaints, String status) {
    if (status == 'All') return complaints;
    return complaints.where((c) => c.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final complaintState = ref.watch(complaintProvider);
    final allComplaints = complaintState.complaints;

    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Complaints Management", style: GoogleFonts.outfit(color: UltimateTheme.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
        bottom: TabBar(
          controller: _tabController,
          labelColor: UltimateTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: UltimateTheme.primaryColor,
          labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Progress"),
            Tab(text: "Resolved"),
            Tab(text: "Rejected"),
          ],
        ),
      ),
      body: complaintState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildComplaintList(context, ref, _filterComplaints(allComplaints, "Pending")),
                _buildComplaintList(context, ref, _filterComplaints(allComplaints, "In Progress")),
                _buildComplaintList(context, ref, _filterComplaints(allComplaints, "Resolved")),
                _buildComplaintList(context, ref, _filterComplaints(allComplaints, "Rejected")),
              ],
            ),
    );
  }

  Widget _buildComplaintList(BuildContext context, WidgetRef ref, List<Complaint> complaints) {
    if (complaints.isEmpty) {
      return Center(child: Text("No complaints in this category", style: GoogleFonts.outfit(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: complaints.length,
      itemBuilder: (context, index) {
        final complaint = complaints[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                      child: Text(complaint.category, style: GoogleFonts.outfit(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    Text(timeago.format(complaint.createdAt), style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(complaint.title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(complaint.description, style: GoogleFonts.outfit(color: Colors.grey[800])),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(complaint.createdByName ?? 'Anonymous', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                    const Spacer(),
                    const Icon(Icons.arrow_upward, size: 14, color: UltimateTheme.primaryColor),
                    Text(" ${complaint.upvotes.length}", style: GoogleFonts.outfit(color: UltimateTheme.primaryColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (complaint.status == 'Pending' || complaint.status == 'In Progress') ...[
                      if (complaint.status == 'Pending')
                        TextButton(
                          onPressed: () => _updateStatus(context, ref, complaint, 'In Progress'),
                          child: Text("Mark In Progress", style: GoogleFonts.outfit(color: Colors.orange)),
                        ),
                      TextButton(
                        onPressed: () => _showResolveDialog(context, ref, complaint, 'Resolved'),
                        child: Text("Resolve", style: GoogleFonts.outfit(color: Colors.green)),
                      ),
                      TextButton(
                        onPressed: () => _showResolveDialog(context, ref, complaint, 'Rejected'),
                        child: Text("Reject", style: GoogleFonts.outfit(color: Colors.red)),
                      ),
                    ] else ...[
                       Text("Resolved by: ${complaint.resolvedBy?['name'] ?? 'Admin'}", style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)), 
                    ]
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateStatus(BuildContext context, WidgetRef ref, Complaint complaint, String status) {
    ref.read(complaintProvider.notifier).updateStatus(complaint.id, status, null);
  }

  void _showResolveDialog(BuildContext context, WidgetRef ref, Complaint complaint, String status) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Mark as $status"),
        content: TextField(
          controller: noteController,
          decoration: const InputDecoration(labelText: "Resolution Note (Optional)", border: OutlineInputBorder()),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              ref.read(complaintProvider.notifier).updateStatus(complaint.id, status, noteController.text);
              Navigator.pop(context);
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
