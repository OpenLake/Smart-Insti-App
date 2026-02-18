import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/confession_provider.dart';
import '../../models/confession.dart';
import 'dart:math';

class ConfessionWallScreen extends ConsumerStatefulWidget {
  const ConfessionWallScreen({super.key});

  @override
  ConsumerState<ConfessionWallScreen> createState() => _ConfessionWallScreenState();
}

class _ConfessionWallScreenState extends ConsumerState<ConfessionWallScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(confessionProvider.notifier).loadConfessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(confessionProvider);

    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Confession Wall", style: GoogleFonts.caveat(color: UltimateTheme.textColor, fontWeight: FontWeight.bold, fontSize: 28)),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
        actions: [
            IconButton(
                icon: const Icon(Icons.refresh, color: UltimateTheme.primaryColor),
                onPressed: () => ref.read(confessionProvider.notifier).loadConfessions(),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/user_home/confessions/add'),
        backgroundColor: UltimateTheme.primaryColor,
        child: const Icon(Icons.create, color: Colors.white),
      ),
      body: state.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : state.confessions.isEmpty 
            ? Center(child: Text("No confessions yet. Be the first!", style: GoogleFonts.caveat(fontSize: 24, color: Colors.grey)))
            : MasonryGridView.count(
                padding: const EdgeInsets.all(16),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                itemCount: state.confessions.length,
                itemBuilder: (context, index) {
                  return _buildConfessionCard(state.confessions[index]);
                },
              ),
    );
  }

  Widget _buildConfessionCard(Confession confession) {
    Color cardColor = Color(int.parse(confession.backgroundColor));
    // Ensure readable text color? Assuming pastels
    Color textColor = Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            confession.content,
            style: GoogleFonts.caveat(fontSize: 18, color: textColor, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Row(
                 children: [
                   GestureDetector(
                     onTap: () => ref.read(confessionProvider.notifier).likeConfession(confession.id),
                     child: Icon(
                        confession.isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: confession.isLiked ? Colors.red : Colors.black54
                     ),
                   ),
                   const SizedBox(width: 4),
                   Text("${confession.likeCount}", style: GoogleFonts.outfit(fontSize: 12, color: Colors.black54)),
                 ],
               ),
               GestureDetector(
                 onTap: () => _reportConfession(confession.id),
                 child: const Icon(Icons.flag_outlined, size: 18, color: Colors.black45),
               )
            ],
          )
        ],
      ),
    );
  }

  void _reportConfession(String id) {
      showDialog(
          context: context, 
          builder: (context) => AlertDialog(
              title: const Text("Report Confession"),
              content: const Text("Are you sure you want to report this confession?"),
              actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                  TextButton(
                      onPressed: () {
                          ref.read(confessionProvider.notifier).reportConfession(id);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reported successfully")));
                      }, 
                      child: const Text("Report", style: TextStyle(color: Colors.red))
                  ),
              ],
          )
      );
  }
}
