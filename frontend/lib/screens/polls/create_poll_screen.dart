
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../theme/ultimate_theme.dart';
import '../../services/poll_service.dart';

class CreatePollScreen extends ConsumerStatefulWidget {
  const CreatePollScreen({super.key});

  @override
  ConsumerState<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends ConsumerState<CreatePollScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
      TextEditingController(),
      TextEditingController()
  ];
  int _expiryHours = 24;
  String _target = "All";
  bool _isLoading = false;

  void _addOption() {
      if (_optionControllers.length < 5) {
          setState(() {
              _optionControllers.add(TextEditingController());
          });
      }
  }

  void _removeOption(int index) {
      if (_optionControllers.length > 2) {
          setState(() {
              _optionControllers.removeAt(index);
          });
      }
  }

  Future<void> _submit() async {
      if (!_formKey.currentState!.validate()) return;

      setState(() => _isLoading = true);

      final options = _optionControllers.map((c) => c.text.trim()).toList();
      final result = await ref.read(pollServiceProvider).createPoll(
          question: _questionController.text.trim(),
          options: options,
          expiryHours: _expiryHours,
          target: _target
      );

      setState(() => _isLoading = false);

      if (mounted) {
          if (result['status'] == true) {
              context.pop(); // Return to previous screen
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Poll created!")));
          } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
          }
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Create Poll", style: GoogleFonts.outfit(color: UltimateTheme.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    TextFormField(
                        controller: _questionController,
                        decoration: InputDecoration(
                            labelText: "Question",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: UltimateTheme.surfaceColor
                        ),
                        maxLines: 2,
                        validator: (v) => v!.trim().isEmpty ? "Question required" : null,
                    ),
                    const SizedBox(height: 24),
                    Text("Options", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    ..._optionControllers.asMap().entries.map((entry) {
                        final index = entry.key;
                        final controller = entry.value;
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                                children: [
                                    Expanded(
                                        child: TextFormField(
                                            controller: controller,
                                            decoration: InputDecoration(
                                                hintText: "Option ${index + 1}",
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                                filled: true,
                                                fillColor: UltimateTheme.surfaceColor,
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                                            ),
                                            validator: (v) => v!.trim().isEmpty ? "Option required" : null,
                                        ),
                                    ),
                                    if (_optionControllers.length > 2)
                                        IconButton(
                                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                                            onPressed: () => _removeOption(index),
                                        )
                                ],
                            ),
                        );
                    }),
                    if (_optionControllers.length < 5)
                        TextButton.icon(
                            onPressed: _addOption,
                            icon: const Icon(Icons.add),
                            label: const Text("Add Option")
                        ),
                    
                    const SizedBox(height: 24),
                    Row(
                        children: [
                            Expanded(
                                child: DropdownButtonFormField<int>(
                                    value: _expiryHours,
                                    decoration: InputDecoration(
                                        labelText: "Duration",
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                        filled: true,
                                        fillColor: UltimateTheme.surfaceColor
                                    ),
                                    items: const [
                                        DropdownMenuItem(value: 24, child: Text("24 Hours")),
                                        DropdownMenuItem(value: 48, child: Text("48 Hours")),
                                        DropdownMenuItem(value: 72, child: Text("3 Days")),
                                        DropdownMenuItem(value: 168, child: Text("1 Week")),
                                    ],
                                    onChanged: (v) => setState(() => _expiryHours = v!),
                                ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                                child: DropdownButtonFormField<String>(
                                    value: _target,
                                    decoration: InputDecoration(
                                        labelText: "Target Users",
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                        filled: true,
                                        fillColor: UltimateTheme.surfaceColor
                                    ),
                                    items: const [
                                        DropdownMenuItem(value: "All", child: Text("All Users")),
                                        DropdownMenuItem(value: "Students", child: Text("Students Only")),
                                    ],
                                    onChanged: (v) => setState(() => _target = v!),
                                ),
                            ),
                        ],
                    ),

                    const SizedBox(height: 32),
                    SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: UltimateTheme.primaryColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                            ),
                            child: _isLoading 
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text("Create Poll", style: GoogleFonts.outfit(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                    )
                ],
            ),
        ),
      ),
    );
  }
}
