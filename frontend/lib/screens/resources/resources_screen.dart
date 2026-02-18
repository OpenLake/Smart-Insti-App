import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/resource_provider.dart';
import 'package:smart_insti_app/models/resource.dart';

class ResourcesScreen extends ConsumerStatefulWidget {
  const ResourcesScreen({super.key});

  @override
  ConsumerState<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends ConsumerState<ResourcesScreen> {
  // Navigation State: 'Root' -> 'Department' -> 'Semester' -> 'Files'
  String _currentView = 'Root'; 
  String? _selectedDept;
  int? _selectedSem;

  final List<String> departments = ['CSE', 'ECE', 'ME', 'CE', 'EEE', 'MME', 'DSAI', 'BT', 'CHE'];
  final List<int> semesters = [1, 2, 3, 4, 5, 6, 7, 8];

  @override
  Widget build(BuildContext context) {
    final resourceState = ref.watch(resourceProvider);

    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Text(_getTitle(), style: GoogleFonts.outfit(color: UltimateTheme.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        leading: _currentView != 'Root' 
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: UltimateTheme.textColor),
              onPressed: _goBack,
            )
          : null,
        actions: [
            IconButton(
                icon: const Icon(Icons.upload_file, color: UltimateTheme.primaryColor),
                onPressed: () => context.push('/user_home/resources/add'),
            )
        ],
      ),
      body: _buildBody(resourceState),
    );
  }

  String _getTitle() {
    if (_currentView == 'Root') return "Study Material";
    if (_currentView == 'Department') return "$_selectedDept Courses";
    if (_currentView == 'Semester') return "$_selectedDept Sem $_selectedSem";
    return "Resources";
  }

  void _goBack() {
    setState(() {
      if (_currentView == 'Semester') {
        _currentView = 'Department';
        _selectedSem = null;
      } else if (_currentView == 'Department') {
        _currentView = 'Root';
        _selectedDept = null;
      }
    });
  }

  Widget _buildBody(ResourceState state) {
    if (_currentView == 'Root') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: departments.length,
          itemBuilder: (context, index) {
            return _buildFolderCard(departments[index], true, () {
              setState(() {
                _selectedDept = departments[index];
                _currentView = 'Department';
              });
            });
          },
        ),
      );
    } else if (_currentView == 'Department') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: semesters.length,
          itemBuilder: (context, index) {
            return _buildFolderCard("Semester ${semesters[index]}", false, () {
               setState(() {
                _selectedSem = semesters[index];
                _currentView = 'Semester';
                // Trigger load
                ref.read(resourceProvider.notifier).selectFolder(_selectedDept!, _selectedSem!, null);
              });
            });
          },
        ),
      );
    } else {
        // Files List
        if (state.isLoading) return const Center(child: CircularProgressIndicator());
        if (state.resources.isEmpty) return const Center(child: Text("No resources found"));

        return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.resources.length,
            itemBuilder: (context, index) => _buildResourceTile(state.resources[index]),
        );
    }
  }

  Widget _buildFolderCard(String title, bool isDept, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
          border: Border.all(color: UltimateTheme.primaryColor.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isDept ? Icons.domain : Icons.folder, size: 48, color: isDept ? Colors.blue : Colors.orange),
            const SizedBox(height: 12),
            Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceTile(Resource resource) {
    return Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
            leading: _getFileIcon(resource.fileUrl),
            title: Text(resource.title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            subtitle: Text("${resource.subject} • ${resource.type}", style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey)),
            trailing: IconButton(
                icon: const Icon(Icons.download_rounded, color: UltimateTheme.primaryColor),
                onPressed: () {
                    // Implement download or open URL
                },
            ),
        ),
    );
  }

  Widget _getFileIcon(String url) {
    if (url.endsWith('.pdf')) return const Icon(Icons.picture_as_pdf, color: Colors.red);
    if (url.endsWith('.jpg') || url.endsWith('.png')) return const Icon(Icons.image, color: Colors.purple);
    return const Icon(Icons.insert_drive_file, color: Colors.grey);
  }
}
