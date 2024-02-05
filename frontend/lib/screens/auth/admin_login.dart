import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/auth/auth_service.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  @override
  Widget build(BuildContext context) {
    final _signInFormKey = GlobalKey<FormState>();
    final AuthService authService = AuthService();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    @override
    void dispose() {
      _emailController.dispose();
      _passwordController.dispose();
    }

    void signInAdmin() {
      authService.signInAdmin(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
        leading: GestureDetector(
          onTap: () {
            context.go('/');
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Welcome Admin',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Sign-In',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.white,
                  child: Form(
                    key: _signInFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(hintText: 'Email'),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(hintText: 'Password'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          child: Text('Sign In'),
                          onPressed: () {
                            if (_signInFormKey.currentState!.validate()) {
                              signInAdmin();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
