import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/resource_provider.dart';

class AddResourceScreen extends ConsumerStatefulWidget {
  const AddResourceScreen({super.key});

  @override
  ConsumerState<AddResourceScreen> createState() => _AddResourceScreenState();
}

class _AddResourceScreenState extends ConsumerState<AddResourceScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isUploading = false;

  final List<String> departments = ['CSE', 'ECE', 'ME', 'CE', 'EEE', 'MME', 'DSAI', 'BT', 'CHE'];
  final List<String> types = ['Notes', 'Paper', 'Book', 'Assignment', 'Other'];

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'jpg', 'png'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      ref.read(resourceProvider.notifier).setPickedFile(file);
      setState(() {});
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true;
      });

      final success = await ref.read(resourceProvider.notifier).uploadResource();

      setState(() {
        _isUploading = false;
      });

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Resource uploaded successfully!")));
        context.pop();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Upload failed. Please try again.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(resourceProvider.notifier);
    // Watch provider to get updates? We are using notifier directly for state here mainly
    
    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Upload Resource", style: GoogleFonts.outfit(color: UltimateTheme.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MaterialTextFormField(
                controller: notifier.titleController,
                hintText: "Title",
                validator: (val) => val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              MaterialTextFormField(
                controller: notifier.descriptionController,
                hintText: "Description (Optional)",
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: notifier.selectedDepartment,
                decoration: const InputDecoration(labelText: "Department", border: OutlineInputBorder()),
                items: departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (val) {
                   if(val != null) notifier.selectedDepartment = val;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: notifier.selectedSemester,
                decoration: const InputDecoration(labelText: "Semester", border: OutlineInputBorder()),
                items: List.generate(8, (index) => index + 1).map((s) => DropdownMenuItem(value: s, child: Text("Semester $s"))).toList(),
                onChanged: (val) {
                   if(val != null) notifier.selectedSemester = val;
                },
              ),
              const SizedBox(height: 16),
              MaterialTextFormField(
                controller: notifier.subjectController,
                hintText: "Subject / Course Code",
                validator: (val) => val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: notifier.selectedType,
                decoration: const InputDecoration(labelText: "Type", border: OutlineInputBorder()),
                items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (val) {
                   if(val != null) notifier.selectedType = val;
                },
              ),
              const SizedBox(height: 24),
              
              // File Picker
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.grey[600]),
                      const SizedBox(height: 8),
                      Text(
                        notifier.pickedFile != null ? notifier.pickedFile!.path.split('/').last : "Tap to upload file",
                        style: GoogleFonts.outfit(color: Colors.grey[800], fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      if (notifier.pickedFile != null)
                          Text("(Tap to change)", style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: _isUploading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: UltimateTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isUploading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("Upload Resource", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
