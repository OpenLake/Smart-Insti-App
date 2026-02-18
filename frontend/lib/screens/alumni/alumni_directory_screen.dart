
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../theme/ultimate_theme.dart';
import '../../services/alumni_service.dart';
import 'alumni_profile_screen.dart';

final alumniFiltersProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  return ref.read(alumniServiceProvider).getFilters();
});

final alumniListProvider = FutureProvider.autoDispose.family<List<dynamic>, Map<String, String?>>((ref, filters) async {
  return ref.read(alumniServiceProvider).getAlumni(
      branch: filters['branch'],
      year: filters['year'],
      search: filters['search']
  );
});

class AlumniDirectoryScreen extends ConsumerStatefulWidget {
  const AlumniDirectoryScreen({super.key});

  @override
  ConsumerState<AlumniDirectoryScreen> createState() => _AlumniDirectoryScreenState();
}

class _AlumniDirectoryScreenState extends ConsumerState<AlumniDirectoryScreen> {
  String? _selectedBranch;
  String? _selectedYear;
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final filtersAsync = ref.watch(alumniFiltersProvider);
    final alumniAsync = ref.watch(alumniListProvider({
        'branch': _selectedBranch,
        'year': _selectedYear,
        'search': _searchController.text.isEmpty ? null : _searchController.text
    }));

    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Alumni Network", style: GoogleFonts.outfit(color: UltimateTheme.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
      ),
      body: Column(
        children: [
            // Search and Filter Header
            Container(
                color: UltimateTheme.surfaceColor,
                padding: const EdgeInsets.all(16),
                child: Column(
                    children: [
                        TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                                hintText: "Search alumni, companies, roles...",
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: UltimateTheme.backgroundColor
                            ),
                            onSubmitted: (_) => setState((){}),
                        ),
                        const SizedBox(height: 12),
                        filtersAsync.when(
                            data: (data) => SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: [
                                        _buildFilterChip("All Branches", _selectedBranch == null, () => setState(() => _selectedBranch = null)),
                                        ...data['branches'].map<Widget>((b) => 
                                            _buildFilterChip(b, _selectedBranch == b, () => setState(() => _selectedBranch = b))
                                        ).toList(),
                                        const SizedBox(width: 16),
                                        _buildFilterChip("All Years", _selectedYear == null, () => setState(() => _selectedYear = null)),
                                        ...data['years'].map<Widget>((y) => 
                                            _buildFilterChip(y.toString(), _selectedYear == y.toString(), () => setState(() => _selectedYear = y.toString()))
                                        ).toList(),
                                    ],
                                ),
                            ),
                            loading: () => const SizedBox(height: 32, child: Center(child: LinearProgressIndicator())),
                            error: (e, s) => const SizedBox()
                        )
                    ],
                ),
            ),
            
            // Alumni List
            Expanded(
                child: alumniAsync.when(
                    data: (alumni) {
                        if (alumni.isEmpty) {
                            return Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        const Icon(Icons.school_outlined, size: 64, color: Colors.grey),
                                        const SizedBox(height: 16),
                                        Text("No alumni found", style: GoogleFonts.outfit(color: Colors.grey, fontSize: 18))
                                    ],
                                )
                            );
                        }
                        return ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: alumni.length,
                            itemBuilder: (context, index) {
                                final alum = alumni[index];
                                return Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    elevation: 2,
                                    child: ListTile(
                                        contentPadding: const EdgeInsets.all(12),
                                        leading: CircleAvatar(
                                            radius: 28,
                                            backgroundImage: alum['profilePicURI'] != null ? NetworkImage(alum['profilePicURI']) : null,
                                            child: alum['profilePicURI'] == null ? Text(alum['name'][0]) : null,
                                        ),
                                        title: Text(alum['name'], style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                                        subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                if (alum['designation'] != null || alum['currentOrganization'] != null)
                                                    Text(
                                                        "${alum['designation'] ?? ''} ${alum['designation'] != null && alum['currentOrganization'] != null ? 'at' : ''} ${alum['currentOrganization'] ?? ''}",
                                                        style: GoogleFonts.outfit(color: Colors.black87)
                                                    ),
                                                Text(
                                                    "${alum['branch'] ?? 'Unknown'} • Class of ${alum['graduationYear'] ?? 'N/A'}",
                                                    style: GoogleFonts.outfit(color: Colors.grey)
                                                ),
                                            ],
                                        ),
                                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                                        onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => AlumniProfileScreen(alumniData: alum)
                                                )
                                            );
                                        },
                                    ),
                                );
                            },
                        );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Center(child: Text("Error: $e"))
                )
            )
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
      return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) => onTap(),
              selectedColor: UltimateTheme.primaryColor.withOpacity(0.2),
              labelStyle: GoogleFonts.outfit(
                  color: isSelected ? UltimateTheme.primaryColor : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
              ),
              checkmarkColor: UltimateTheme.primaryColor,
          ),
      );
  }
}
