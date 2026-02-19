import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
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
      backgroundColor: Colors.transparent,
      floatingActionButton: currentUserRole == 'admin' || currentUserRole == 'faculty'
          ? FloatingActionButton(
              onPressed: () => _showAddLinkDialog(context, ref),
              backgroundColor: UltimateTheme.primary,
              child: const Icon(Icons.add, color: Colors.white),
            ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack)
          : null,
      body: linkState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // 1. Emergency Application Header & Grid
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Text(
                      "Emergency Contacts",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.5,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                         final contact = _emergencyContacts[index];
                         return _buildEmergencyCard(contact);
                      },
                      childCount: _emergencyContacts.length,
                    ),
                  ),
                ),

                // 2. Hostel Administration Header & List
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      "Hostel Administration",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: UltimateTheme.primary,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final contact = _hostelContacts[index];
                      return _buildContactTile(contact);
                    },
                    childCount: _hostelContacts.length,
                  ),
                ),

                // 3. Mess Administration Header & List
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      "Mess Administration",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: UltimateTheme.primary,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final contact = _messContacts[index];
                      return _buildContactTile(contact);
                    },
                    childCount: _messContacts.length,
                  ),
                ),

                // 4. Important Links Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      "Important Links",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: UltimateTheme.textMain,
                      ),
                    ),
                  ),
                ),
                
                // 5. Existing Links Grid
                linkState.links.isEmpty 
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.link_off_rounded, size: 64, color: UltimateTheme.textSub.withOpacity(0.5)),
                            const SizedBox(height: 16),
                            Text("No links found", style: GoogleFonts.inter(color: UltimateTheme.textSub)),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.1,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final link = linkState.links[index];
                            return _buildLinkCard(link, index);
                          },
                          childCount: linkState.links.length,
                        ),
                      ),
                    ),
              ],
            ),
    );
  }

  final List<Map<String, String>> _emergencyContacts = [
    {"title": "Ambulance", "number": "07647068419"},
    {"title": "Health Center", "number": "07882991612"},
    {"title": "Health Center (Alt)", "number": "09424283691"},
    {"title": "Security (Main Gate)", "number": "+91-1234567890"}, // Keep if no update
    {"title": "Anti-Ragging", "number": "1800-180-5522"}, 
    {"title": "Women Helpline", "number": "1091"},
  ];

  final List<Map<String, String>> _hostelContacts = [
    {"title": "Kanhar Warden", "subtitle": "Dr. Vinod Reddy", "email": "warden_kanhar@iitbhilai.ac.in"},
    {"title": "Kanhar Office", "subtitle": "Mr. Yashavant Kumar", "email": "hostel_kanhar@iitbhilai.ac.in"},
    {"title": "Gopad Warden", "subtitle": "Dr. Yagnesh Shadangi", "email": "warden_gopad@iitbhilai.ac.in"},
    {"title": "Gopad Office", "subtitle": "Mr. Mahesh P Koli", "email": "hostel_gopad@iitbhilai.ac.in"},
    {"title": "Indravati Warden", "subtitle": "Dr. Swati Yadav", "email": "warden_indravati@iitbhilai.ac.in"},
    {"title": "Indravati Office", "subtitle": "Mrs. Aanchal Lal", "email": "hostel_indravati@iitbhilai.ac.in"},
    {"title": "Shivnath Warden", "subtitle": "Dr. Raghavender Medishetty", "email": "warden_shivnath@iitbhilai.ac.in"},
    {"title": "Shivnath Office", "subtitle": "Mr. Piyush Shukla", "email": "hostel_shivnath@iitbhilai.ac.in"},
  ];

  final List<Map<String, String>> _messContacts = [
    {"title": "Mess FIC", "subtitle": "Dr. Ganapathy", "email": "messblock@iitbhilai.ac.in"},
    {"title": "Mess Staff", "subtitle": "Mr. Mahesh Koli", "email": "maheshpk@iitbhilai.ac.in"},
    {"title": "Mess Committee", "subtitle": "General", "email": "messcoordinator@iitbhilai.ac.in"},
  ];

  Widget _buildContactTile(Map<String, String> contact) {
    return ListTile(
      title: Text(contact['title']!, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
      subtitle: Text(contact['subtitle']!, style: GoogleFonts.outfit(fontSize: 12)),
      trailing: IconButton(
        icon: const Icon(Icons.email_outlined, color: UltimateTheme.primary),
        onPressed: () => _launchUrl("mailto:${contact['email']}"),
      ),
    );
  }

  Widget _buildEmergencyCard(Map<String, String> contact) {
    return InkWell(
      onTap: () => _launchUrl("tel:${contact['number']}"),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade100),
        ),
        child: Row(
          children: [
            const Icon(Icons.phone_in_talk_rounded, color: Colors.red, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    contact['title']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.red.shade900,
                    ),
                  ),
                  Text(
                    contact['number']!,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildLinkCard(link, int index) {
    return InkWell(
      onTap: () => _launchUrl(link.url),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: UltimateTheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.link_rounded, color: UltimateTheme.primary, size: 24),
            ),
            const Spacer(),
            Text(
              link.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: UltimateTheme.textMain,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              link.category.toUpperCase(),
              style: GoogleFonts.spaceGrotesk(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: UltimateTheme.accent,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutQuad);
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
