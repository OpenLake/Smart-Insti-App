
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/ultimate_theme.dart';
import '../../services/search_service.dart';

final searchResultsProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, query) async {
  if (query.length < 2) return {};
  return ref.read(searchServiceProvider).search(query);
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = "";

  @override
  Widget build(BuildContext context) {
    // Only search if query length is >= 2
    final searchAsync = ref.watch(searchResultsProvider(_query));

    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
        title: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
                hintText: "Search students, faculty, events...",
                border: InputBorder.none,
                hintStyle: GoogleFonts.outfit(color: Colors.grey)
            ),
            style: GoogleFonts.outfit(color: UltimateTheme.textColor),
            onChanged: (val) {
                // Debounce could be added here
                if (val.length >= 2) {
                    setState(() => _query = val);
                } else {
                    setState(() => _query = "");
                }
            },
        ),
      ),
      body: _query.length < 2 
        ? Center(child: Text("Type at least 2 characters", style: GoogleFonts.outfit(color: Colors.grey)))
        : searchAsync.when(
            data: (data) {
                if (data.isEmpty || (data['students']?.isEmpty ?? true) && (data['faculty']?.isEmpty ?? true) && (data['events']?.isEmpty ?? true) && (data['news']?.isEmpty ?? true) && (data['buses']?.isEmpty ?? true)) {
                    return Center(child: Text("No results found", style: GoogleFonts.outfit(color: Colors.grey)));
                }
                
                return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                        if (data['students'] != null && data['students'].isNotEmpty)
                            _buildSection("Students", data['students'], (item) => ListTile(
                                leading: CircleAvatar(backgroundImage: item['profilePicURI'] != null ? NetworkImage(item['profilePicURI']) : null),
                                title: Text(item['name']),
                                subtitle: Text("${item['branch']} • ${item['rollNumber'] ?? ''}"),
                            )),
                        
                        if (data['faculty'] != null && data['faculty'].isNotEmpty)
                            _buildSection("Faculty", data['faculty'], (item) => ListTile(
                                leading: const Icon(Icons.person_pin, color: Colors.blue),
                                title: Text(item['name']),
                                subtitle: Text("${item['department']} • ${item['cabinNumber'] ?? ''}"),
                            )),

                        if (data['events'] != null && data['events'].isNotEmpty)
                            _buildSection("Events", data['events'], (item) => ListTile(
                                leading: const Icon(Icons.event, color: Colors.purple),
                                title: Text(item['title']),
                                subtitle: Text("${item['location']} • ${item['date'] ?? ''}"),
                            )),

                        if (data['news'] != null && data['news'].isNotEmpty)
                            _buildSection("News & Posts", data['news'], (item) => ListTile(
                                leading: const Icon(Icons.article, color: Colors.orange),
                                title: Text(item['title']),
                                subtitle: Text(item['type']),
                            )),

                        if (data['buses'] != null && data['buses'].isNotEmpty)
                            _buildSection("Transport", data['buses'], (item) => ListTile(
                                leading: const Icon(Icons.directions_bus, color: Colors.red),
                                title: Text(item['routeName']),
                                subtitle: Text(item['busNumber'] ?? ''),
                            )),
                    ],
                );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text("Error: $e"))
        ),
    );
  }

  Widget _buildSection(String title, List items, Widget Function(dynamic) itemBuilder) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: UltimateTheme.primaryColor)),
              const SizedBox(height: 8),
              Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                      children: items.map<Widget>((item) => itemBuilder(item)).toList(),
                  ),
              ),
              const SizedBox(height: 16),
          ],
      );
  }
}
