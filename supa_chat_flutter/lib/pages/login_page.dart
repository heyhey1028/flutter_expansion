import 'package:flutter/material.dart';
import 'package:supa_chat_flutter/pages/signup_page.dart';
import 'package:supa_chat_flutter/widgets/app_logo.dart';
import 'package:supa_chat_flutter/widgets/app_text_form_field.dart';

import '../widgets/app_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogo(),
                const SizedBox(height: 24),
                const Text(
                  'Welcom back',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                const Form(
                  child: Column(
                    children: [
                      AppTextFormField(
                        labelText: 'Email address',
                      ),
                      SizedBox(height: 24),
                      AppTextFormField(
                        labelText: 'Password',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  height: 48,
                  onPressed: () async {},
                  text: 'Continue',
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Don't have an account?"),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ),
                        );
                      },
                      child: const Text('Sign up'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
