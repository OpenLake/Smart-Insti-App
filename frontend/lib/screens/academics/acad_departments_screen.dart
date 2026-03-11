import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/provider/acadmap_provider.dart';

class AcadDepartmentsScreen extends ConsumerStatefulWidget {
  const AcadDepartmentsScreen({super.key});

  @override
  ConsumerState<AcadDepartmentsScreen> createState() =>
      _AcadDepartmentsScreenState();
}

class _AcadDepartmentsScreenState extends ConsumerState<AcadDepartmentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(acadmapProvider.notifier).fetchDepartments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(acadmapProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text("Error: ${state.error}"))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: state.departments.length,
                  itemBuilder: (context, index) {
                    final dept = state.departments[index];
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                            color: Colors.teal.withValues(alpha: 0.1)),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.withValues(alpha: 0.1),
                          child: Text(
                            dept.shortName[0],
                            style: const TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          dept.fullName,
                          style: GoogleFonts.spaceGrotesk(
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(dept.shortName),
                      ),
                    );
                  },
                ),
    );
  }
}
