import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/provider/link_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../components/borderless_button.dart';
import '../../provider/auth_provider.dart';

class LinksPage extends ConsumerStatefulWidget {
  const LinksPage({super.key});

  @override
  ConsumerState<LinksPage> createState() => _LinksPageState();
}

class _LinksPageState extends ConsumerState<LinksPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(linkProvider.notifier).loadLinks();
    });
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not launch $url")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final linkState = ref.watch(linkProvider);
    final currentUserRole = ref.watch(authProvider).currentUserRole;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Links'),
      ),
      floatingActionButton: currentUserRole == 'admin' || currentUserRole == 'faculty'
          ? FloatingActionButton(
              onPressed: () {
                _showAddLinkDialog(context, ref);
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: linkState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : linkState.links.isEmpty
              ? const Center(child: Text("No links found"))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: linkState.links.length,
                  itemBuilder: (context, index) {
                    final link = linkState.links[index];
                    return InkWell(
                      onTap: () => _launchUrl(link.url),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.link, size: 40, color: Colors.blue),
                            const SizedBox(height: 8),
                            Text(
                              link.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              link.category,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showAddLinkDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Link'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialTextFormField(
                controller: ref.read(linkProvider.notifier).titleController,
                hintText: 'Title',
              ),
              const SizedBox(height: 10),
              MaterialTextFormField(
                controller: ref.read(linkProvider.notifier).urlController,
                hintText: 'URL (e.g. https://google.com)',
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: "Other",
                items: ["Academic", "Hostel", "Club", "Other"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) ref.read(linkProvider.notifier).updateCategory(val);
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
              ref.read(linkProvider.notifier).addLink();
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
