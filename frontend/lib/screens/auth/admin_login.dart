import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../components/borderless_button.dart';
import '../../components/material_textformfield.dart';
import '../../constants/constants.dart';
import '../../provider/auth_provider.dart';

class AdminLogin extends ConsumerWidget {
  const AdminLogin({super.key});

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
                                    builder: (_, ref, __) => const Text(
                                      'Admin Login',
                                      style: TextStyle(fontSize: 30, fontFamily: 'Jost'),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Hero(
                                  tag: 'admin_page',
                                  child: SizedBox(
                                    width: 95,
                                    child: BorderlessButton(
                                      onPressed: () => context.pop(),
                                      backgroundColor: Colors.tealAccent.withOpacity(0.5),
                                      label: const Text('Back'),
                                      splashColor: Colors.teal.shade700,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            MaterialTextFormField(
                              hintText: "Email",
                              validator: (value) => Validators.emailValidator(value),
                            ),
                            const SizedBox(height: 20),
                            MaterialTextFormField(hintText: "Password"),
                            const SizedBox(height: 20),
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
