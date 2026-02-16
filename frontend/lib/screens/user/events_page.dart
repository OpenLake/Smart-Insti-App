import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart'; // Add Google Fonts import
import 'package:intl/intl.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/provider/event_provider.dart';
import '../../components/borderless_button.dart';
import '../../provider/auth_provider.dart';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventProvider.notifier).loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventProvider);
    final currentUserRole = ref.watch(authProvider).currentUserRole;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events & Calendar'),
      ),
      floatingActionButton: currentUserRole == 'admin' || currentUserRole == 'faculty'
          ? FloatingActionButton(
              onPressed: () {
                _showAddEventDialog(context, ref);
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: eventState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : eventState.events.isEmpty
              ? const Center(child: Text("No upcoming events"))
              : ListView.builder(
                  itemCount: eventState.events.length,
                  itemBuilder: (context, index) {
                    final event = eventState.events[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.withOpacity(0.1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Date Badge
                            Container(
                              width: 60,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('dd').format(event.date),
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('MMM').format(event.date).toUpperCase(),
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.title,
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    event.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(fontSize: 14, color: Colors.black54),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          event.location,
                                          style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Delete Action (Admin Only)
                            if (currentUserRole == 'admin')
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () {
                                  ref.read(eventProvider.notifier).deleteEvent(event.id);
                                },
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showAddEventDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialTextFormField(
                controller: ref.read(eventProvider.notifier).titleController,
                hintText: 'Event Title',
              ),
              const SizedBox(height: 10),
              MaterialTextFormField(
                controller: ref.read(eventProvider.notifier).descriptionController,
                hintText: 'Description',
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              MaterialTextFormField(
                controller: ref.read(eventProvider.notifier).locationController,
                hintText: 'Location',
              ),
              const SizedBox(height: 10),
              MaterialTextFormField(
                controller: ref.read(eventProvider.notifier).organizedByController,
                hintText: 'Organized By',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    ref.read(eventProvider.notifier).updateDate(picked);
                  }
                },
                child: const Text("Select Date"),
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
              ref.read(eventProvider.notifier).addEvent();
              context.pop();
            },
            label: const Text('Add'),
            backgroundColor: Colors.green.shade100,
            splashColor: Colors.green.shade200,
          ),
        ],
      ),
    );
  }
}
