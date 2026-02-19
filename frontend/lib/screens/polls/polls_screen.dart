
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../theme/ultimate_theme.dart';
import '../../services/poll_service.dart';
import '../../provider/auth_provider.dart';
import 'package:intl/intl.dart';

final activePollsProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  return ref.read(pollServiceProvider).getActivePolls();
});

class PollsScreen extends StatelessWidget {
  const PollsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Polls", style: GoogleFonts.outfit(color: UltimateTheme.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
      ),
      body: const PollListWidget(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/user_home/polls/create'),
        backgroundColor: UltimateTheme.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text("Create Poll", style: GoogleFonts.outfit(color: Colors.white)),
      ),
    );
  }
}

class PollListWidget extends ConsumerWidget {
  const PollListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pollsAsync = ref.watch(activePollsProvider);

    return pollsAsync.when(
        data: (polls) {
            if (polls.isEmpty) {
                return Center(child: Text("No active polls", style: GoogleFonts.outfit(color: Colors.grey)));
            }
            return RefreshIndicator(
              onRefresh: () async => ref.refresh(activePollsProvider),
              child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: polls.length,
                  itemBuilder: (context, index) {
                      return _PollCard(poll: polls[index]);
                  },
              ),
            );
        },
        error: (err, stack) => Center(child: Text("Error: $err")),
        loading: () => const Center(child: CircularProgressIndicator()),
      );
  }
}

class _PollCard extends ConsumerStatefulWidget {
    final Map<String, dynamic> poll;
    const _PollCard({required this.poll});

    @override
    ConsumerState<_PollCard> createState() => _PollCardState();
}

class _PollCardState extends ConsumerState<_PollCard> {
    bool _voting = false;

    Future<void> _vote(int index) async {
        setState(() => _voting = true);
        final result = await ref.read(pollServiceProvider).vote(widget.poll['_id'], index);
        
        if (mounted) {
            setState(() => _voting = false);
            if (result['status'] == true) {
                ref.refresh(activePollsProvider);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vote recorded!")));
            } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
            }
        }
    }

    @override
    Widget build(BuildContext context) {
        final currentUser = ref.read(authProvider).currentUser;
        final isCreator = currentUser != null && widget.poll['createdBy']['_id'] == (currentUser as dynamic).id;

        final hasVoted = widget.poll['hasVoted'] == true;
        final totalVotes = widget.poll['totalVotes'] as int;
        final options = List<Map<String, dynamic>>.from(widget.poll['options']);

        return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: UltimateTheme.surfaceColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Expanded(child: Text(widget.poll['question'], style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold))),
                            if (isCreator)
                                IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                                    onPressed: () => _confirmDelete(),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                )
                        ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                        "Created by ${widget.poll['createdBy']['name']} • Ends ${DateFormat('MMM dd').format(DateTime.parse(widget.poll['expiry']))}",
                        style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)
                    ),
                    const SizedBox(height: 16),
                    ...options.asMap().entries.map((entry) {
                        final index = entry.key;
                        final option = entry.value;
                        final votes = option['votes'] as int;
                        final percentage = totalVotes > 0 ? (votes / totalVotes) : 0.0;

                        return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: hasVoted 
                                ? _buildResultBar(option['text'], votes, percentage)
                                : _buildVoteButton(index, option['text']),
                        );
                    }),
                    if (hasVoted)
                        Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                                "Total Votes: $totalVotes", 
                                style: GoogleFonts.outfit(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)
                            ),
                        )
                ],
            ),
        );
    }

    void _confirmDelete() {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                title: const Text("Delete Poll"),
                content: const Text("Are you sure you want to delete this poll?"),
                actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
                    TextButton(
                        onPressed: () async {
                            Navigator.pop(ctx);
                            final success = await ref.read(pollServiceProvider).deletePoll(widget.poll['_id']);
                            if (success) {
                                ref.refresh(activePollsProvider);
                                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Poll deleted")));
                            } else {
                                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to delete poll")));
                            }
                        },
                        child: const Text("Delete", style: TextStyle(color: Colors.red)),
                    )
                ],
            )
        );
    }

    Widget _buildVoteButton(int index, String text) {
        return SizedBox(
            width: double.infinity,
            child: OutlinedButton(
                onPressed: _voting ? null : () => _vote(index),
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: UltimateTheme.primaryColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                ),
                child: _voting 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                    : Text(text, style: GoogleFonts.outfit(color: UltimateTheme.primaryColor)),
            ),
        );
    }

    Widget _buildResultBar(String text, int votes, double percentage) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(text, style: GoogleFonts.outfit(fontWeight: FontWeight.w500)),
                        Text("${(percentage * 100).toStringAsFixed(1)}%", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                    ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                        value: percentage,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(UltimateTheme.primaryColor),
                        minHeight: 8,
                    ),
                ),
            ],
        );
    }
}
