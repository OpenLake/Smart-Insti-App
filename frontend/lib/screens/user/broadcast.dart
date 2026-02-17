import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/broadcast_provider.dart';
import 'package:smart_insti_app/models/broadcast_schema.dart';

class BroadcastPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcasts = ref.watch(broadcastProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: broadcasts.when(
        data: (broadcastList) {
          if (broadcastList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.campaign_rounded, size: 64, color: UltimateTheme.textSub.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text("No broadcasts yet.", style: GoogleFonts.inter(color: UltimateTheme.textSub)),
                ],
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final broadcast = broadcastList[index];
                      return _buildBroadcastCard(broadcast, index);
                    },
                    childCount: broadcastList.length,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildBroadcastCard(Broadcast broadcast, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: UltimateTheme.primary.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 6, color: UltimateTheme.primary),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              broadcast.title,
                              style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 18, color: UltimateTheme.textMain),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: UltimateTheme.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${broadcast.date.day}/${broadcast.date.month}',
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: UltimateTheme.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        broadcast.body,
                        style: GoogleFonts.inter(color: UltimateTheme.textSub, height: 1.5, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1);
  }
}
