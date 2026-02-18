
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../theme/ultimate_theme.dart';
import '../../models/student.dart';
// Note: We'll fetch student details using a provider. For now assuming we pass the object or ID.
// Reusing StudentProfileScreen logic but tailored for Alumni

class AlumniProfileScreen extends ConsumerWidget {
  final Map<String, dynamic> alumniData; // Passing data directly for MVP simplicity

  const AlumniProfileScreen({super.key, required this.alumniData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: UltimateTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      UltimateTheme.primaryColor,
                      UltimateTheme.primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: alumniData['profilePicURI'] != null
                            ? NetworkImage(alumniData['profilePicURI'])
                            : null,
                        backgroundColor: Colors.white,
                        child: alumniData['profilePicURI'] == null
                            ? Text(alumniData['name'][0], style: const TextStyle(fontSize: 40, color: UltimateTheme.primaryColor))
                            : null,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        alumniData['name'],
                        style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Professional Info"),
                  _buildInfoCard(
                      Icons.business, 
                      "Organization", 
                      alumniData['currentOrganization'] ?? "Not Listed"
                  ),
                  _buildInfoCard(
                      Icons.work, 
                      "Designation", 
                      alumniData['designation'] ?? "Not Listed"
                  ),
                   _buildInfoCard(
                      Icons.link, 
                      "LinkedIn", 
                      alumniData['linkedInProfile'] ?? "Not Linked",
                      isLink: true
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle("Academic Info"),
                  _buildInfoCard(Icons.school, "Branch", alumniData['branch'] ?? "Unknown"),
                  _buildInfoCard(Icons.calendar_today, "Class of", "${alumniData['graduationYear'] ?? 'Unknown'}"),

                  const SizedBox(height: 24),
                  _buildSectionTitle("Contact"),
                  _buildInfoCard(Icons.email, "Email", alumniData['email']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: UltimateTheme.primaryColor),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value, {bool isLink = false}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: UltimateTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: UltimateTheme.primaryColor),
        ),
        title: Text(label, style: GoogleFonts.outfit(color: Colors.grey[600], fontSize: 12)),
        subtitle: Text(
            value, 
            style: GoogleFonts.outfit(
                color: isLink ? Colors.blue : Colors.black87, 
                fontSize: 16, 
                fontWeight: FontWeight.w500,
                decoration: isLink ? TextDecoration.underline : null
            )
        ),
        onTap: isLink && value != "Not Linked" ? () {
            // Launch URL logic here
        } : null,
      ),
    );
  }
}
