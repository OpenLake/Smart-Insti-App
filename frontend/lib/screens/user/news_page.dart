import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/post_provider.dart';
import '../../components/borderless_button.dart';
import '../../provider/auth_provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:smart_insti_app/models/student.dart';
import 'package:smart_insti_app/models/faculty.dart';
import 'package:smart_insti_app/models/admin.dart';
import 'package:smart_insti_app/models/alumni.dart';

class NewsPage extends ConsumerStatefulWidget {
  const NewsPage({super.key});

  @override
  ConsumerState<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends ConsumerState<NewsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postProvider.notifier).loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(postProvider);
    final currentUserRole = ref.watch(authProvider).currentUserRole;
    final currentUser = ref.watch(authProvider).currentUser;
    String currentUserEmail = "";
    if (currentUser != null) {
      if (currentUser is Student) currentUserEmail = currentUser.email;
      else if (currentUser is Faculty) currentUserEmail = currentUser.email;
      else if (currentUser is Admin) currentUserEmail = currentUser.email;
      else if (currentUser is Alumni) currentUserEmail = currentUser.email;
    }

    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by MainScaffold
      floatingActionButton: currentUserRole == 'admin' || currentUserRole == 'faculty'
          ? FloatingActionButton(
              onPressed: () => _showAddPostDialog(context, ref),
              backgroundColor: UltimateTheme.primary,
              child: const Icon(Icons.add, color: Colors.white),
            ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack)
          : null,
      body: postState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : postState.posts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.article_outlined, size: 64, color: UltimateTheme.textSub.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Text("No news posts for now", style: GoogleFonts.inter(color: UltimateTheme.textSub)),
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
                            final post = postState.posts[index];
                            return _buildNewsCard(post, currentUserEmail, index);
                          },
                          childCount: postState.posts.length,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildNewsCard(post, String currentUserEmail, int index) {
    final bool isLiked = post.likes.contains(currentUserEmail);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: UltimateTheme.primary.withOpacity(0.08)),
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        gradient: UltimateTheme.brandGradient,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Text(
                          post.author.isNotEmpty ? post.author[0].toUpperCase() : "?",
                          style: GoogleFonts.spaceGrotesk(
                            color: UltimateTheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                post.author,
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              if (post.type == "Announcement") ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.verified_rounded, color: UltimateTheme.accent, size: 14),
                              ],
                            ],
                          ),
                          Text(
                            timeago.format(post.createdAt),
                            style: GoogleFonts.inter(color: UltimateTheme.textSub, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz_rounded, color: UltimateTheme.textSub),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  post.title,
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    height: 1.2,
                    color: UltimateTheme.textMain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post.content,
                  style: GoogleFonts.inter(
                    color: UltimateTheme.textMain.withOpacity(0.8),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: UltimateTheme.primary.withOpacity(0.02),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Row(
              children: [
                _buildActionButton(
                  isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                  "${post.likes.length}",
                  isLiked ? Colors.redAccent : UltimateTheme.textSub,
                ),
                const SizedBox(width: 20),
                _buildActionButton(Icons.chat_bubble_outline_rounded, "12", UltimateTheme.textSub),
                const Spacer(),
                Icon(Icons.share_outlined, size: 20, color: UltimateTheme.textSub),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1, curve: Curves.easeOutQuad);
  }

  Widget _buildActionButton(IconData icon, String count, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 6),
        Text(
          count,
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  void _showAddPostDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Post'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialTextFormField(
                controller: ref.read(postProvider.notifier).titleController,
                hintText: 'Title',
              ),
              const SizedBox(height: 10),
              MaterialTextFormField(
                controller: ref.read(postProvider.notifier).contentController,
                hintText: 'Content',
                maxLines: 5,
              ),
              const SizedBox(height: 10),
              MaterialTextFormField(
                controller: ref.read(postProvider.notifier).authorController,
                hintText: 'Author Name',
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
              ref.read(postProvider.notifier).addPost();
              context.pop();
            },
            label: const Text('Post'),
            backgroundColor: Colors.green.shade100,
            splashColor: Colors.green.shade200,
          ),
        ],
      ),
    );
  }
}
