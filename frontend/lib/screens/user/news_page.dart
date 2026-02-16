import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart'; // Add Google Fonts import
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/provider/post_provider.dart';
import '../../components/borderless_button.dart';
import '../../provider/auth_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed & News'),
      ),
      floatingActionButton: currentUserRole == 'admin' || currentUserRole == 'faculty'
          ? FloatingActionButton(
              onPressed: () {
                _showAddPostDialog(context, ref);
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: postState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : postState.posts.isEmpty
              ? const Center(child: Text("No posts yet"))
              : ListView.builder(
                  itemCount: postState.posts.length,
                  itemBuilder: (context, index) {
                    final post = postState.posts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  child: Text(
                                    post.author.isNotEmpty ? post.author[0].toUpperCase() : "?",
                                    style: GoogleFonts.outfit(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.author,
                                        style: GoogleFonts.outfit(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        timeago.format(post.createdAt),
                                        style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                if (post.type == "Announcement")
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Official",
                                      style: GoogleFonts.outfit(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              post.title,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              post.content,
                              style: GoogleFonts.outfit(fontSize: 14, color: Colors.black54),
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    ref.read(postProvider.notifier).likePost(post.id);
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.thumb_up_alt_outlined, size: 20, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text("${post.likes.length}", style: GoogleFonts.outfit(color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
