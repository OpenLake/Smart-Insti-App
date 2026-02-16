import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'In Progress':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final complaintState = ref.watch(complaintProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaints & Feedback'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddComplaintDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
      body: complaintState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : complaintState.complaints.isEmpty
              ? const Center(child: Text("No complaints found"))
              : ListView.builder(
                  itemCount: complaintState.complaints.length,
                  itemBuilder: (context, index) {
                    final complaint = complaintState.complaints[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  label: Text(complaint.category, style: const TextStyle(fontSize: 10)),
                                  visualDensity: VisualDensity.compact,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(complaint.status).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: _getStatusColor(complaint.status)),
                                  ),
                                  child: Text(
                                    complaint.status,
                                    style: TextStyle(
                                      color: _getStatusColor(complaint.status),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              complaint.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              complaint.description,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "By: ${complaint.createdByName ?? 'Unknown'}",
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.thumb_up_alt_outlined),
                                  onPressed: () {
                                    ref.read(complaintProvider.notifier).upvoteComplaint(complaint.id);
                                  },
                                ),
                                Text("${complaint.upvotes.length}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showAddComplaintDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Complaint'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialTextFormField(
                controller: ref.read(complaintProvider.notifier).titleController,
                hintText: 'Title',
              ),
              const SizedBox(height: 10),
              MaterialTextFormField(
                controller: ref.read(complaintProvider.notifier).descriptionController,
                hintText: 'Description',
                maxLines: 4,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: "Other",
                items: ["Mess", "Hostel Infrastructure", "Academic", "Other"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) ref.read(complaintProvider.notifier).updateCategory(val);
                },
                decoration: const InputDecoration(labelText: "Category"),
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
              ref.read(complaintProvider.notifier).addComplaint();
              context.pop();
            },
            label: const Text('Submit'),
            backgroundColor: Colors.green.shade100,
            splashColor: Colors.green.shade200,
          ),
        ],
      ),
    );
  }
}
