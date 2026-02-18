import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/provider/confession_provider.dart';

class AddConfessionScreen extends ConsumerStatefulWidget {
  const AddConfessionScreen({super.key});

  @override
  ConsumerState<AddConfessionScreen> createState() => _AddConfessionScreenState();
}

class _AddConfessionScreenState extends ConsumerState<AddConfessionScreen> {
  final TextEditingController _controller = TextEditingController();
  String _selectedColor = "0xFFE0F7FA"; // Default Light Cyan
  bool _isPosting = false;

  final List<String> _colors = [
    "0xFFE0F7FA", // Cyan
    "0xFFF3E5F5", // Purple
    "0xFFE8F5E9", // Green
    "0xFFFFF3E0", // Orange
    "0xFFFFEBEE", // Red
    "0xFFE3F2FD", // Blue
    "0xFFFFF8E1", // Amber
    "0xFFECEFF1", // Grey
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Text("New Confession", style: GoogleFonts.outfit(color: UltimateTheme.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
        actions: [
            TextButton(
                onPressed: _isPosting ? null : _postConfession,
                child: _isPosting 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text("Post", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: UltimateTheme.primaryColor)),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pick a color", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _colors.length,
                    itemBuilder: (context, index) {
                        final colorHex = _colors[index];
                        final color = Color(int.parse(colorHex));
                        return GestureDetector(
                            onTap: () => setState(() => _selectedColor = colorHex),
                            child: Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: _selectedColor == colorHex ? Border.all(color: UltimateTheme.primaryColor, width: 2) : null,
                                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2, offset: const Offset(0, 1))],
                                ),
                                child: _selectedColor == colorHex ? const Icon(Icons.check, size: 20, color: Colors.black54) : null,
                            ),
                        );
                    },
                ),
            ),
            const SizedBox(height: 24),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color(int.parse(_selectedColor)),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: TextField(
                        controller: _controller,
                        maxLines: null,
                        maxLength: 500,
                        style: GoogleFonts.caveat(fontSize: 24, height: 1.5, color: Colors.black87),
                        decoration: const InputDecoration(
                            hintText: "Type your confession here...",
                            border: InputBorder.none,
                            counterText: "",
                        ),
                    ),
                ),
            ),
            const SizedBox(height: 10),
            Text("Confessions are anonymous but moderated. Be kind.", style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Future<void> _postConfession() async {
      if (_controller.text.trim().isEmpty) return;

      setState(() => _isPosting = true);
      
      final success = await ref.read(confessionProvider.notifier).createConfession(
          _controller.text.trim(), 
          _selectedColor
      );

      setState(() => _isPosting = false);

      if (success && mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Confession posted!")));
      } else if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to post confession")));
      }
  }
}
