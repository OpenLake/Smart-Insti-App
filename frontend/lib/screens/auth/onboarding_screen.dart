import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants/constants.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rollNumberController = TextEditingController();
  final _aboutController = TextEditingController();
  final _cabinNumberController = TextEditingController();
  String? _selectedBranch;
  int? _selectedBatch;

  final List<String> _branches = [
    'Computer Science and Engineering',
    'Data Science and Artificial Intelligence',
    'Electronics and Communication Engineering',
    'Electrical Engineering',
    'Electric Vehicle Technology',
    'Mechanical Engineering',
    'Mechatronics Engineering',
    'Materials Science and Metallurgical Engineering',
    'Physics',
    'Mathematics',
    'Chemistry',
    'Bioscience and Biomedical Engineering',
    'Liberal Arts',
  ];

  final List<int> _batches =
      List.generate(10, (index) => DateTime.now().year + index - 2);

  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    // Pre-fill fields from Supabase metadata if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      final sbUser = authState.sbUser;
      if (sbUser != null) {
        final metaName = sbUser.userMetadata?['full_name'] ??
            sbUser.userMetadata?['name'] ??
            '';
        if (metaName.isNotEmpty) {
          _nameController.text = metaName;
        }

        final metaRole = sbUser.userMetadata?['role'];
        if (metaRole != null) {
          setState(() => _selectedRole = metaRole);
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rollNumberController.dispose();
    _aboutController.dispose();
    _cabinNumberController.dispose();
    super.dispose();
  }

  String get _currentRole {
    return _selectedRole ?? ref.read(authProvider).currentUserRole ?? 'student';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final role = _currentRole;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: UltimateTheme.brandGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Welcome icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.waving_hand_rounded,
                          size: 48, color: Colors.white),
                    ).animate().scale(curve: Curves.easeOutBack),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome!',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ).animate().fadeIn().slideY(begin: 0.2),
                    const SizedBox(height: 8),
                    Text(
                      "Let's set up your profile",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 32),

                    // Form Card
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: UltimateTheme.surface,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Complete Your Profile',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: UltimateTheme.textMain,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Fill in your details to get started.',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: UltimateTheme.textSub,
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Role Selection (if not already set or for Google users)
                            DropdownButtonFormField<String>(
                              value: _selectedRole,
                              decoration: InputDecoration(
                                labelText: 'I am a...',
                                prefixIcon:
                                    const Icon(Icons.person_search_rounded),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      color: UltimateTheme.textSub
                                          .withValues(alpha: 0.2)),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: 'student', child: Text('Student')),
                                DropdownMenuItem(
                                    value: 'faculty', child: Text('Faculty')),
                                DropdownMenuItem(
                                    value: 'alumni', child: Text('Alumni')),
                              ],
                              onChanged: (val) =>
                                  setState(() => _selectedRole = val),
                              validator: (val) =>
                                  val == null ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),

                            // Name (common for all roles)
                            MaterialTextFormField(
                              controller: _nameController,
                              hintText: 'Full Name',
                              prefixIcon:
                                  const Icon(Icons.person_outline_rounded),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Role-specific fields
                            if (role == 'student') ..._buildStudentFields(),
                            if (role == 'faculty') ..._buildFacultyFields(),
                            if (role == 'alumni') ..._buildAlumniFields(),

                            // About (common, optional)
                            const SizedBox(height: 16),
                            MaterialTextFormField(
                              controller: _aboutController,
                              hintText: 'About you (optional)',
                              prefixIcon: const Icon(Icons.info_outline),
                              maxLines: 3,
                            ),

                            const SizedBox(height: 36),
                            ElevatedButton(
                              onPressed: authState.loginProgressState ==
                                      LoadingState.progress
                                  ? null
                                  : _onFinishOnboarding,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(56),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                              child: authState.loginProgressState ==
                                      LoadingState.progress
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white))
                                  : Text(
                                      'Finish Setup',
                                      style: GoogleFonts.spaceGrotesk(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStudentFields() {
    return [
      MaterialTextFormField(
        controller: _rollNumberController,
        hintText: 'Roll Number (e.g. 12140840)',
        prefixIcon: const Icon(Icons.badge_outlined),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Roll Number is required';
          return null;
        },
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        value: _selectedBranch,
        decoration: InputDecoration(
          labelText: 'Branch / Department',
          prefixIcon: const Icon(Icons.account_tree_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: UltimateTheme.textSub.withValues(alpha: 0.2)),
          ),
        ),
        items: _branches
            .map((b) => DropdownMenuItem(
                value: b, child: Text(b, overflow: TextOverflow.ellipsis)))
            .toList(),
        onChanged: (val) => setState(() => _selectedBranch = val),
        validator: (val) => val == null ? 'Required' : null,
        isExpanded: true,
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<int>(
        value: _selectedBatch,
        decoration: InputDecoration(
          labelText: 'Graduation Year',
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: UltimateTheme.textSub.withValues(alpha: 0.2)),
          ),
        ),
        items: _batches
            .map((b) => DropdownMenuItem(value: b, child: Text(b.toString())))
            .toList(),
        onChanged: (val) => setState(() => _selectedBatch = val),
        validator: (val) => val == null ? 'Required' : null,
      ),
    ];
  }

  List<Widget> _buildFacultyFields() {
    return [
      DropdownButtonFormField<String>(
        value: _selectedBranch,
        decoration: InputDecoration(
          labelText: 'Department',
          prefixIcon: const Icon(Icons.business_rounded),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: UltimateTheme.textSub.withValues(alpha: 0.2)),
          ),
        ),
        items: _branches
            .map((b) => DropdownMenuItem(
                value: b, child: Text(b, overflow: TextOverflow.ellipsis)))
            .toList(),
        onChanged: (val) => setState(() => _selectedBranch = val),
        validator: (val) => val == null ? 'Required' : null,
        isExpanded: true,
      ),
      const SizedBox(height: 16),
      MaterialTextFormField(
        controller: _cabinNumberController,
        hintText: 'Cabin / Office Number',
        prefixIcon: const Icon(Icons.meeting_room_outlined),
      ),
    ];
  }

  List<Widget> _buildAlumniFields() {
    return [
      DropdownButtonFormField<String>(
        value: _selectedBranch,
        decoration: InputDecoration(
          labelText: 'Department',
          prefixIcon: const Icon(Icons.school_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: UltimateTheme.textSub.withValues(alpha: 0.2)),
          ),
        ),
        items: _branches
            .map((b) => DropdownMenuItem(
                value: b, child: Text(b, overflow: TextOverflow.ellipsis)))
            .toList(),
        onChanged: (val) => setState(() => _selectedBranch = val),
        validator: (val) => val == null ? 'Required' : null,
        isExpanded: true,
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<int>(
        value: _selectedBatch,
        decoration: InputDecoration(
          labelText: 'Graduation Year',
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: UltimateTheme.textSub.withValues(alpha: 0.2)),
          ),
        ),
        items: _batches
            .map((b) => DropdownMenuItem(value: b, child: Text(b.toString())))
            .toList(),
        onChanged: (val) => setState(() => _selectedBatch = val),
        validator: (val) => val == null ? 'Required' : null,
      ),
    ];
  }

  Future<void> _onFinishOnboarding() async {
    if (!_formKey.currentState!.validate()) return;

    final role = _currentRole;
    final Map<String, dynamic> profileData = {
      'name': _nameController.text.trim(),
      'role': role,
    };

    if (_aboutController.text.isNotEmpty) {
      profileData['about'] = _aboutController.text.trim();
    }

    switch (role) {
      case 'student':
        profileData['student_id'] = _rollNumberController.text.trim();
        profileData['department'] = _selectedBranch;
        profileData['batch'] = _selectedBatch;
        break;
      case 'faculty':
        profileData['department'] = _selectedBranch;
        if (_cabinNumberController.text.isNotEmpty) {
          profileData['about'] =
              '${profileData['about'] ?? ''}\nCabin: ${_cabinNumberController.text.trim()}'
                  .trim();
        }
        break;
      case 'alumni':
        profileData['department'] = _selectedBranch;
        profileData['batch'] = _selectedBatch;
        break;
    }

    // Also update Supabase auth metadata with the role so future logins recognize it
    await Supabase.instance.client.auth.updateUser(
      UserAttributes(data: {'role': role}),
    );

    final success = await ref
        .read(authProvider.notifier)
        .updateProfile(context, profileData);
    if (success && mounted) {
      context.go('/user_home');
    }
  }
}
