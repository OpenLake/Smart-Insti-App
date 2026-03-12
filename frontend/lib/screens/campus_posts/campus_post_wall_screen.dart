import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/campus_post_provider.dart';
import '../../models/campus_post.dart';
import 'dart:math';

class CampusPostWallScreen extends StatelessWidget {
  const CampusPostWallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Ask Your Campus",
            style: GoogleFonts.spaceGrotesk(
                color: UltimateTheme.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 24)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/user_home/campus-posts/add'),
        backgroundColor: UltimateTheme.primary,
        child: const Icon(Icons.create, color: Colors.white),
      ),
      body: const CampusPostListWidget(),
    );
  }
}

class CampusPostListWidget extends ConsumerStatefulWidget {
  const CampusPostListWidget({super.key});

  @override
  ConsumerState<CampusPostListWidget> createState() =>
      _CampusPostListWidgetState();
}

class _CampusPostListWidgetState extends ConsumerState<CampusPostListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(campusPostProvider.notifier).loadPosts(refresh: true);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(campusPostProvider.notifier).loadPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(campusPostProvider);

    return state.isLoading
        ? const Center(child: CircularProgressIndicator())
        : state.posts.isEmpty
            ? Center(
                child: Text("No posts yet. Be the first!",
                    style:
                        GoogleFonts.spaceGrotesk(fontSize: 20, color: Colors.grey)))
            : RefreshIndicator(
                onRefresh: () async => ref
                    .read(campusPostProvider.notifier)
                    .loadPosts(refresh: true),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverMasonryGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childCount: state.posts.length,
                        itemBuilder: (context, index) {
                          return _buildPostCard(state.posts[index]);
                        },
                      ),
                    ),
                    if (state.isLoadingMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                  ],
                ),
              );
  }

  Widget _buildPostCard(CampusPost post) {
    Color cardColor = Color(int.parse(post.backgroundColor));
    Color textColor = Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.content,
            style: GoogleFonts.spaceGrotesk(
                fontSize: 16, color: textColor, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => ref
                        .read(campusPostProvider.notifier)
                        .likePost(post.id),
                    child: Icon(
                        post.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 20,
                        color:
                            post.isLiked ? Colors.red : Colors.black54),
                  ),
                  const SizedBox(width: 4),
                  Text("${post.likeCount}",
                      style: GoogleFonts.outfit(
                          fontSize: 12, color: Colors.black54)),
                ],
              ),
              GestureDetector(
                onTap: () => _reportPost(post.id),
                child: const Icon(Icons.flag_outlined,
                    size: 18, color: Colors.black45),
              )
            ],
          )
        ],
      ),
    );
  }

  void _reportPost(String id) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Report Post"),
              content: const Text(
                  "Are you sure you want to report this campus post?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      ref
                          .read(campusPostProvider.notifier)
                          .reportPost(id);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Reported successfully")));
                    },
                    child: const Text("Report",
                        style: TextStyle(color: Colors.red))),
              ],
            ));
  }
}
