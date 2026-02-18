
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/theme_provider.dart';
import 'package:smart_insti_app/services/auth/auth_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Local state for UI toggles (will be synced with backend in real app)
  bool _emailNotifs = true;
  bool _pushNotifs = true;
  bool _showEmail = true;
  bool _showAchievements = true;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Settings", style: GoogleFonts.outfit(color: UltimateTheme.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Appearance"),
            _buildSwitchTile(
              "Dark Mode", 
              "Easy on the eyes", 
              isDarkMode, 
              (val) => ref.read(themeProvider.notifier).toggleTheme()
            ),

            const SizedBox(height: 24),
            _buildSectionHeader("Notifications"),
            _buildSwitchTile(
              "Email Notifications", 
              "Receive updates via email", 
              _emailNotifs, 
              (val) => setState(() => _emailNotifs = val)
            ),
            _buildSwitchTile(
              "Push Notifications", 
              "Receive updates on this device", 
              _pushNotifs, 
              (val) => setState(() => _pushNotifs = val)
            ),

            const SizedBox(height: 24),
            _buildSectionHeader("Privacy"),
            _buildSwitchTile(
              "Show Email", 
              "Visible to other students", 
              _showEmail, 
              (val) => setState(() => _showEmail = val)
            ),
            _buildSwitchTile(
              "Show Achievements", 
              "Display badges on profile", 
              _showAchievements, 
              (val) => setState(() => _showAchievements = val)
            ),

            const SizedBox(height: 32),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: () async {
                       await ref.read(authServiceProvider).logout();
                       // Navigation handled by auth listener or manual push replacement
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: Text("Logout", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                    ),
                ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: UltimateTheme.primaryColor),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Card(
      elevation: 0,
      color: UltimateTheme.surfaceColor,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.withOpacity(0.1))),
      child: SwitchListTile(
        title: Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
        value: value,
        onChanged: onChanged,
        activeColor: UltimateTheme.primaryColor,
      ),
    );
  }
}
