import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/constants/constants.dart';

class OTPVerificationScreen extends ConsumerStatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  ConsumerState<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends ConsumerState<OTPVerificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).initializeOtpFocusNodes();
    });
  }

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

              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.mark_email_read_rounded,
                                  size: 80,
                                  color: Colors.white,
                                ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                                const SizedBox(height: 24),
                                Text(
                                  'Verify Email',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ).animate().fadeIn().slideY(begin: 0.2),
                                const SizedBox(height: 8),
                                Text(
                                  'We sent an 8-digit code to\n${authState.emailController.text}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ).animate().fadeIn(delay: 200.ms),
                                const SizedBox(height: 48),

                                // OTP Input Card
                                Container(
                                  padding: const EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.95),
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
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: List.generate(
                                          8,
                                          (index) => SizedBox(
                                            width: 38,
                                            height: 50,
                                            child: TextField(
                                              controller: authState.otpDigitControllers[index],
                                              focusNode: authState.otpFocusNodes[index],
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.number,
                                              maxLength: 1,
                                              style: GoogleFonts.spaceGrotesk(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: UltimateTheme.primary,
                                              ),
                                              decoration: InputDecoration(
                                                counterText: "",
                                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  borderSide: BorderSide(color: UltimateTheme.primary.withValues(alpha: 0.2)),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  borderSide: const BorderSide(color: UltimateTheme.primary, width: 2),
                                                ),
                                                fillColor: UltimateTheme.primary.withValues(alpha: 0.05),
                                                filled: true,
                                              ),
                                              onChanged: (value) {
                                                if (value.length == 1 && index < 7) {
                                                  authState.otpFocusNodes[index + 1].requestFocus();
                                                }
                                                if (value.isEmpty && index > 0) {
                                                  authState.otpFocusNodes[index - 1].requestFocus();
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 32),
                                      ElevatedButton(
                                        onPressed: authState.loginProgressState == LoadingState.progress
                                            ? null
                                            : () async {
                                                if (await ref.read(authProvider.notifier).verifyEmailOTP(context)) {
                                                  if (context.mounted) {
                                                    if (ref.read(authProvider).needsOnboarding) {
                                                      context.go('/onboarding');
                                                    } else {
                                                      context.go('/user_home');
                                                    }
                                                  }
                                                }
                                              },
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size.fromHeight(56),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        ),
                                        child: authState.loginProgressState == LoadingState.progress
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                              )
                                            : const Text('Verify & Continue'),
                                      ),
                                    ],
                                  ),
                                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

                                const SizedBox(height: 32),
                                TextButton(
                                  onPressed: () {
                                    // Resend logic could be added here
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Resend functionality coming soon!")),
                                    );
                                  },
                                  child: Text(
                                    "Didn't receive code? Resend",
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
