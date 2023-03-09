import 'package:almost_zenly/components/auth_modal/components/animated_error_message.dart';
import 'package:almost_zenly/components/auth_modal/components/auth_modal_image.dart';
import 'package:almost_zenly/components/auth_modal/components/auth_text_form_field.dart';
import 'package:almost_zenly/components/auth_modal/components/submit_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ---------  Validation ---------

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    if (value != _passwordController.text) {
      return 'Password does not match';
    }
    return null;
  }

  // ---------  stateChages ---------

  void _setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void _setErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
  }

  void _clearErrorMessage() {
    setState(() {
      errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          const AuthModalImage(),
          const SizedBox(height: 16.0),
          AnimatedErrorMessage(errorMessage: errorMessage),
          const SizedBox(height: 16.0),
          AuthTextFormField(
            controller: _emailController,
            onChanged: (value) => _clearErrorMessage(),
            validator: validateEmail,
            labelText: 'Email',
          ),
          const SizedBox(height: 32.0),
          AuthTextFormField(
            controller: _passwordController,
            obscureText: true,
            onChanged: (value) => _clearErrorMessage(),
            validator: validatePassword,
            labelText: 'Password',
          ),
          const SizedBox(height: 32.0),
          AuthTextFormField(
            obscureText: true,
            onChanged: (value) => _clearErrorMessage(),
            validator: validateConfirmPassword,
            labelText: 'Confirm Password',
          ),
          const SizedBox(height: 32.0),
          SubmitButton(
            labelName: '新規登録',
            onTap: () => _submit(context),
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  // ---------  Sign Up ---------

  Future<UserCredential?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      _setIsLoading(true);
      print('isloading: $isLoading');
      return await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'weak-password') {
        _setErrorMessage('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _setErrorMessage('The account already exists for that email.');
      } else {
        _setErrorMessage('an unidentified error occurred while signing up.');
      }
    } finally {
      _setIsLoading(false);
    }
    return null;
  }

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final user = await signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      if (user != null) {
        Navigator.of(context).pop();
      }
    }
  }
}
