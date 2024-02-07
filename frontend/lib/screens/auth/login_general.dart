import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_insti_app/components/borderless_button.dart';
import 'package:smart_insti_app/components/material_textformfield.dart';
import 'package:smart_insti_app/components/otp_box.dart';
import 'package:smart_insti_app/constants/constants.dart';
import 'package:smart_insti_app/provider/auth_provider.dart';

class GeneralLogin extends ConsumerWidget {
  const GeneralLogin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: IntrinsicHeight(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Consumer(
                                    builder: (_, ref, __) => Text(
                                      ref.watch(authProvider).switchAuthLabel == AuthConstants.studentAuthLabel
                                          ? 'Student Login'
                                          : 'Faculty Login',
                                      style: const TextStyle(fontSize: 30, fontFamily: 'Jost'),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Hero(
                                  tag: 'admin_page',
                                  child: BorderlessButton(
                                    onPressed: () => context.push('/admin_login'),
                                    backgroundColor: Colors.tealAccent.withOpacity(0.5),
                                    label: const Text('Admin'),
                                    splashColor: Colors.teal.shade700,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            MaterialTextFormField(
                              hintText: "Email",
                              validator: (value) => Validators.emailValidator(value),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: ref.watch(authProvider).switchAuthLabel == AuthConstants.studentAuthLabel
                                  ? SizedBox(
                                      child: Column(children: [
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            MaterialOTPBox(
                                              controller: TextEditingController(),
                                              focusNode: FocusNode(),
                                              hintText: 'O',
                                            ),
                                            MaterialOTPBox(
                                              controller: TextEditingController(),
                                              focusNode: FocusNode(),
                                              hintText: 'T',
                                            ),
                                            MaterialOTPBox(
                                              controller: TextEditingController(),
                                              focusNode: FocusNode(),
                                              hintText: 'P',
                                            ),
                                            MaterialOTPBox(
                                              controller: TextEditingController(),
                                              focusNode: FocusNode(),
                                              hintText: ':)',
                                            )
                                          ],
                                        ),
                                      ]),
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Consumer(
                                builder: (_, ref, __) => AnimatedToggleSwitch.dual(
                                  height: 45,
                                  spacing: 40,
                                  current: ref.watch(authProvider).switchAuthLabel,
                                  first: AuthConstants.studentAuthLabel,
                                  second: AuthConstants.facultyAuthLabel,
                                  onChanged: (value) => ref.read(authProvider.notifier).toggleAuthSwitch(),
                                  textBuilder: (value) => Text(value),
                                  styleBuilder: (value) => value == AuthConstants.studentAuthLabel
                                      ? ToggleStyle(
                                          indicatorColor: Colors.redAccent,
                                          backgroundColor: Colors.redAccent.shade100,
                                          borderColor: Colors.transparent,
                                        )
                                      : ToggleStyle(
                                          indicatorColor: Colors.teal,
                                          backgroundColor: Colors.tealAccent.shade100,
                                          borderColor: Colors.transparent,
                                        ),
                                  iconBuilder: (value) => value == AuthConstants.studentAuthLabel
                                      ? const Icon(
                                          Icons.book_outlined,
                                          color: Colors.white,
                                        )
                                      : const Icon(
                                          Icons.portrait_rounded,
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Consumer(
                                  builder: (_, ref, __) => ref.watch(authProvider).emailSent
                                      ? SizedBox(
                                          height: 45,
                                          width: 100,
                                          child: BorderlessButton(
                                            onPressed: () {},
                                            backgroundColor: Colors.lightBlueAccent.withOpacity(0.5),
                                            label: const Text('Resend'),
                                            splashColor: Colors.blue.shade700,
                                          ),
                                        )
                                      : Container(),
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: 45,
                                  width: 100,
                                  child: BorderlessButton(
                                    onPressed: () {},
                                    backgroundColor: Colors.orangeAccent.withOpacity(0.5),
                                    label: const Text('Login'),
                                    splashColor: Colors.orange.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 80, horizontal: 35),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Smart Insti',
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
