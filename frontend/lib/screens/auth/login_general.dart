import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smart_insti_app/components/borderless_button.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/constants/constants.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';

class GeneralLogin extends ConsumerStatefulWidget {
  const GeneralLogin({super.key});

  @override
  ConsumerState<GeneralLogin> createState() => _GeneralLoginState();
}

class _GeneralLoginState extends ConsumerState<GeneralLogin> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  bool _isLoginMode = true;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: UltimateTheme.brandGradient,
          ),
          child: Stack(
            children: [
              // Decorative background elements
              Positioned(
                top: -100,
                right: -100,
                child: CircleAvatar(
                  radius: 150,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              Positioned(
                bottom: -50,
                left: -50,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                ),
              ),

              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        // Logo/App Name
                        Text(
                          'Smart Insti',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -1.5,
                          ),
                        ).animate().fadeIn().slideY(begin: 0.2),
                        const SizedBox(height: 8),
                        Text(
                          'Your Campus, Simplified.',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ).animate().fadeIn(delay: 200.ms),
                        const SizedBox(height: 48),

                        // Login Card
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: UltimateTheme.surface.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 40,
                                offset: const Offset(0, 20),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _isLoginMode
                                        ? (authState.switchAuthLabel ==
                                                AuthConstants.studentAuthLabel
                                            ? 'Student Login'
                                            : 'Faculty Login')
                                        : 'Create Account',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: UltimateTheme.textMain,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        context.push('/login/admin_login'),
                                    icon: const Icon(
                                        Icons.admin_panel_settings_rounded,
                                        color: UltimateTheme.primary),
                                    tooltip: 'Admin Login',
                                  ).animate().scale(),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Form(
                                key: _emailFormKey,
                                child: Column(
                                  children: [
                                    MaterialTextFormField(
                                      hintText: "Institutional Email",
                                      prefixIcon: const Icon(
                                          Icons.email_outlined,
                                          size: 20),
                                      validator: (value) =>
                                          Validators.emailValidator(value),
                                      controller: authState.emailController,
                                    ),
                                    const SizedBox(height: 16),
                                    MaterialTextFormField(
                                      hintText: "Password",
                                      prefixIcon: const Icon(
                                          Icons.lock_outline_rounded,
                                          size: 20),
                                      controller: authState.passwordController,
                                      obscureText: true,
                                      validator: (value) =>
                                          Validators.nonEmptyValidator(value),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              CustomToggleSwitch(
                                  ref: ref, authState: authState),
                              const SizedBox(height: 32),
                              ElevatedButton(
                                onPressed: authState.loginProgressState ==
                                        LoadingState.progress
                                    ? null
                                    : () async {
                                        if (_emailFormKey.currentState!
                                            .validate()) {
                                          if (_isLoginMode) {
                                            if (await ref
                                                    .read(authProvider.notifier)
                                                    .loginWithPassword(
                                                        context) &&
                                                context.mounted) {
                                              if (ref
                                                  .read(authProvider)
                                                  .needsOnboarding) {
                                                context.go('/onboarding');
                                              } else {
                                                context.go('/user_home');
                                              }
                                              ref
                                                  .read(authProvider.notifier)
                                                  .clearControllers();
                                            }
                                          } else {
                                            if (await ref
                                                    .read(authProvider.notifier)
                                                    .signUpWithPassword(
                                                        context) &&
                                                context.mounted) {
                                              // Success message or navigation handled in Provider
                                            }
                                          }
                                        }
                                      },
                                child: authState.loginProgressState ==
                                        LoadingState.progress
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white))
                                    : Text(_isLoginMode ? 'Login' : 'Sign Up'),
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton.icon(
                                onPressed: authState.loginProgressState ==
                                        LoadingState.progress
                                    ? null
                                    : () async {
                                        await ref
                                            .read(authProvider.notifier)
                                            .loginWithGoogle(context);
                                      },
                                icon: Image.network(
                                  'https://raw.githubusercontent.com/eshenhu/google-insider/refs/heads/master/google_logo.png',
                                  height: 20,
                                  errorBuilder: (_, __, ___) => const Icon(
                                      Icons.g_mobiledata_rounded,
                                      size: 24),
                                ),
                                label: Text(
                                  'Sign in with Google',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: UltimateTheme.textMain),
                                ),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(56),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  side: BorderSide(
                                      color: UltimateTheme.textSub
                                          .withValues(alpha: 0.2)),
                                ),
                              ).animate().fadeIn(delay: 100.ms),
                              const SizedBox(height: 16),
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLoginMode = !_isLoginMode;
                                    });
                                  },
                                  child: Text(
                                    _isLoginMode
                                        ? "Need an account? Sign Up"
                                        : "Already have an account? Login",
                                    style: GoogleFonts.inter(
                                        color: UltimateTheme.primary,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

                        const SizedBox(height: 32),

                        // Alternative Actions
                        Column(
                          children: [
                            TextButton(
                              onPressed: () => context.go('/'),
                              child: Text(
                                "Continue as Guest",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {}, // Removed demo logic for now
                              child: Text(
                                "Supabase Powered Auth",
                                style: GoogleFonts.inter(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 600.ms),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomToggleSwitch extends StatelessWidget {
  final WidgetRef ref;
  final AuthState authState;

  const CustomToggleSwitch(
      {super.key, required this.ref, required this.authState});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: UltimateTheme.textMain.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: AnimatedToggleSwitch<String>.size(
        current: authState.switchAuthLabel,
        values: const [
          AuthConstants.studentAuthLabel,
          AuthConstants.facultyAuthLabel
        ],
        onChanged: authState.emailSendingState == LoadingState.progress
            ? (value) {}
            : (value) => ref.read(authProvider.notifier).toggleAuthSwitch(),
        indicatorSize: const Size.fromWidth(150),
        style: ToggleStyle(
          backgroundColor: Colors.transparent,
          indicatorColor: Colors.white,
          indicatorBorderRadius: BorderRadius.circular(12),
          indicatorBoxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        iconBuilder: (value) => Text(
          value,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: value == authState.switchAuthLabel
                ? UltimateTheme.primary
                : UltimateTheme.textSub,
          ),
        ),
      ),
    );
  }
}
