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
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Could not launch $url")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final linkState = ref.watch(linkProvider);
    final currentUserRole = ref.watch(authProvider).currentUserRole;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton:
          currentUserRole == 'admin' || currentUserRole == 'faculty'
              ? FloatingActionButton.extended(
                  onPressed: () => _showAddLinkDialog(context, ref),
                  backgroundColor: UltimateTheme.primary,
                  elevation: 4,
                  icon: const Icon(Icons.add_link_rounded, color: Colors.white),
                  label: Text("Add Link",
                      style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack)
              : null,
      body: linkState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. Emergency Application Header & Grid
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Row(
                      children: [
                        const Icon(Icons.emergency_rounded,
                            color: Colors.redAccent, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          "Emergency Contacts",
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: UltimateTheme.textMain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.3,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final contact = _emergencyContacts[index];
                        return _buildEmergencyCard(contact, index);
                      },
                      childCount: _emergencyContacts.length,
                    ),
                  ),
                ),

                // 2. Hostel Administration
                _buildSectionHeader(
                    "Hostel Administration", Icons.business_rounded),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final contact = _hostelContacts[index];
                        return _buildContactTile(contact, index);
                      },
                      childCount: _hostelContacts.length,
                    ),
                  ),
                ),

                // 3. Mess Administration
                _buildSectionHeader(
                    "Mess Administration", Icons.restaurant_menu_rounded),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final contact = _messContacts[index];
                        return _buildContactTile(contact, index);
                      },
                      childCount: _messContacts.length,
                    ),
                  ),
                ),

                // 4. Important Links
                _buildSectionHeader("Important Links", Icons.link_rounded),

                // 5. Existing Links Grid
                linkState.links.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 60),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: UltimateTheme.primary
                                        .withValues(alpha: 0.05),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.link_off_rounded,
                                      size: 64,
                                      color: UltimateTheme.primary
                                          .withValues(alpha: 0.3)),
                                ),
                                const SizedBox(height: 24),
                                Text("No useful links yet",
                                    style: GoogleFonts.spaceGrotesk(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: UltimateTheme.textMain)),
                                Text("Check back later for curated resources",
                                    style: GoogleFonts.inter(
                                        color: UltimateTheme.textSub)),
                              ],
                            ).animate().fadeIn(),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.15,
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
        child: Row(
          children: [
            Icon(icon, color: UltimateTheme.primary, size: 22),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: UltimateTheme.textMain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Map<String, String>> _emergencyContacts = [
    {"title": "Ambulance", "number": "07647068419"},
    {"title": "Health Center", "number": "07882991612"},
    {"title": "Health Center (Alt)", "number": "09424283691"},
    {"title": "Security (Gate)", "number": "+91-1234567890"},
    {"title": "Anti-Ragging", "number": "1800-180-5522"},
    {"title": "Women Helpline", "number": "1091"},
  ];

  final List<Map<String, String>> _hostelContacts = [
    {
      "title": "Kanhar Warden",
      "subtitle": "Dr. Vinod Reddy",
      "email": "warden_kanhar@iitbhilai.ac.in"
    },
    {
      "title": "Kanhar Office",
      "subtitle": "Mr. Yashavant Kumar",
      "email": "hostel_kanhar@iitbhilai.ac.in"
    },
    {
      "title": "Gopad Warden",
      "subtitle": "Dr. Yagnesh Shadangi",
      "email": "warden_gopad@iitbhilai.ac.in"
    },
    {
      "title": "Gopad Office",
      "subtitle": "Mr. Mahesh P Koli",
      "email": "hostel_gopad@iitbhilai.ac.in"
    },
    {
      "title": "Indravati Warden",
      "subtitle": "Dr. Swati Yadav",
      "email": "warden_indravati@iitbhilai.ac.in"
    },
    {
      "title": "Indravati Office",
      "subtitle": "Mrs. Aanchal Lal",
      "email": "hostel_indravati@iitbhilai.ac.in"
    },
    {
      "title": "Shivnath Warden",
      "subtitle": "Dr. Raghavender Medishetty",
      "email": "warden_shivnath@iitbhilai.ac.in"
    },
    {
      "title": "Shivnath Office",
      "subtitle": "Mr. Piyush Shukla",
      "email": "hostel_shivnath@iitbhilai.ac.in"
    },
  ];

  final List<Map<String, String>> _messContacts = [
    {
      "title": "Mess FIC",
      "subtitle": "Dr. Ganapathy",
      "email": "messblock@iitbhilai.ac.in"
    },
    {
      "title": "Mess Staff",
      "subtitle": "Mr. Mahesh Koli",
      "email": "maheshpk@iitbhilai.ac.in"
    },
    {
      "title": "Mess Committee",
      "subtitle": "General",
      "email": "messcoordinator@iitbhilai.ac.in"
    },
  ];

  Widget _buildContactTile(Map<String, String> contact, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: UltimateTheme.primary.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        title: Text(contact['title']!,
            style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: UltimateTheme.textMain)),
        subtitle: Text(contact['subtitle']!,
            style: GoogleFonts.inter(
                fontSize: 13,
                color: UltimateTheme.textSub,
                fontWeight: FontWeight.w500)),
        trailing: Container(
          decoration: BoxDecoration(
            color: UltimateTheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.email_rounded,
                color: UltimateTheme.primary, size: 20),
            onPressed: () => _launchUrl("mailto:${contact['email']}"),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.05);
  }

  Widget _buildEmergencyCard(Map<String, String> contact, int index) {
    return InkWell(
      onTap: () => _launchUrl("tel:${contact['number']}"),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade50.withValues(alpha: 0.8), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.phone_in_talk_rounded,
                  color: Colors.redAccent, size: 18),
            ),
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
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.red.shade900,
                    ),
                  ),
                  Text(
                    contact['number']!,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade700.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (index * 40).ms)
        .scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildLinkCard(link, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border:
            Border.all(color: UltimateTheme.primary.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _launchUrl(link.url),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: UltimateTheme.brandGradientSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.link_rounded,
                    color: UltimateTheme.primary, size: 22),
              ),
              const Spacer(),
              Text(
                link.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: UltimateTheme.textMain,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: UltimateTheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  link.category.toUpperCase(),
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: UltimateTheme.primary,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (index * 60).ms)
        .scale(begin: const Offset(0.9, 0.9));
  }

  void _showAddLinkDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        title: Text('New Quick Link',
            style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.bold, fontSize: 24)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MaterialTextFormField(
                  controller: ref.read(linkProvider.notifier).titleController,
                  hintText: 'Link Title',
                  prefixIcon: const Icon(Icons.title_rounded),
                ),
                const SizedBox(height: 16),
                MaterialTextFormField(
                  controller: ref.read(linkProvider.notifier).urlController,
                  hintText: 'URL (e.g. iitbhilai.ac.in)',
                  prefixIcon: const Icon(Icons.link_rounded),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: "Other",
                  items: ["Academic", "Hostel", "Club", "Other"]
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e,
                              style: GoogleFonts.inter(
                                  fontSize: 14, fontWeight: FontWeight.w500))))
                      .toList(),
                  onChanged: (val) {
                    if (val != null)
                      ref.read(linkProvider.notifier).updateCategory(val);
                  },
                  icon: const Icon(Icons.arrow_drop_down_rounded,
                      color: UltimateTheme.primary),
                  decoration: InputDecoration(
                    labelText: "Link Category",
                    labelStyle: GoogleFonts.inter(
                        color: UltimateTheme.textSub, fontSize: 14),
                    filled: true,
                    fillColor: UltimateTheme.primary.withValues(alpha: 0.05),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: UltimateTheme.primary.withValues(alpha: 0.1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: UltimateTheme.primary.withValues(alpha: 0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                          color: UltimateTheme.primary, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actions: [
          Row(
            children: [
              Expanded(
                child: BorderlessButton(
                  onPressed: () => context.pop(),
                  label: const Text('Cancel'),
                  backgroundColor:
                      UltimateTheme.textSub.withValues(alpha: 0.05),
                  splashColor: UltimateTheme.textSub,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BorderlessButton(
                  onPressed: () {
                    ref.read(linkProvider.notifier).addLink();
                    context.pop();
                  },
                  label: const Text('Save Link'),
                  backgroundColor: UltimateTheme.primary.withValues(alpha: 0.1),
                  splashColor: UltimateTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
