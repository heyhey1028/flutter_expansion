import 'package:flutter/material.dart';
import 'package:supa_chat_flutter/widgets/app_logo.dart';
import 'package:supa_chat_flutter/widgets/app_text_form_field.dart';

import '../widgets/app_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
                  'Create your account',
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
                      SizedBox(height: 24),
                      AppTextFormField(
                        labelText: 'Confirm Password',
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
                    const Text('Already have an account?'),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Log in'),
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
