import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../components/material_textformfield.dart';
import '../../constants/constants.dart';
import '../../provider/auth_provider.dart';
import '../../theme/ultimate_theme.dart';

class AdminLogin extends ConsumerWidget {
  AdminLogin({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                          'Administrator Portal',
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
                            color: Colors.white.withValues(alpha: 0.9),
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
                                    'Admin Login',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: UltimateTheme.textMain,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => context.pop(),
                                    icon: const Icon(Icons.arrow_back_rounded,
                                        color: UltimateTheme.primary),
                                    tooltip: 'Back',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    MaterialTextFormField(
                                      controller: authState.emailController,
                                      hintText: "Admin Email",
                                      prefixIcon: const Icon(
                                          Icons.admin_panel_settings_outlined,
                                          size: 20),
                                      validator: (value) =>
                                          Validators.emailValidator(value),
                                    ),
                                    const SizedBox(height: 20),
                                    MaterialTextFormField(
                                      controller: authState.passwordController,
                                      hintText: "Password",
                                      prefixIcon: const Icon(
                                          Icons.lock_outline_rounded,
                                          size: 20),
                                      obscureText: true,
                                      validator: (value) =>
                                          Validators.nonEmptyValidator(value),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              ElevatedButton(
                                onPressed: (authState.loginProgressState ==
                                        LoadingState.progress)
                                    ? null
                                    : () async {
                                        if (formKey.currentState!.validate()) {
                                          if (await ref
                                                  .read(authProvider.notifier)
                                                  .loginWithPassword(context) &&
                                              context.mounted) {
                                            ref
                                                .read(authProvider.notifier)
                                                .clearControllers();
                                            context.go('/');
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
                                    : const Text('Login as Administrator'),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                        const SizedBox(height: 60),
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
