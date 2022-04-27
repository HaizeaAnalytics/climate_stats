import 'package:climate_stats/authentication_service.dart';
import 'package:climate_stats/reset_password.dart';
import 'package:climate_stats/sign_in_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: InputFields(),
    );
  }
}

class InputFields extends StatefulWidget {
  const InputFields({Key? key}) : super(key: key);

  @override
  State<InputFields> createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Password Visibility
  bool _isHidden = true;

  // Initialise controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      // Background image
      decoration: BoxDecoration(
          image: DecorationImage(
        image: const AssetImage("background.jpg"),
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withAlpha(100), BlendMode.darken),
      )),

      // Sign up form
      child: Form(
        key: _formKey,
        child: Center(
          child: SizedBox(
            width: 800,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Heading text
                const Text(
                  "Sign up for an account",
                  style: TextStyle(color: Colors.white),
                ),

                // Sized box (defines width of child text fields)
                SizedBox(
                  width: 500,
                  child: Column(
                    children: [
                      // Email Field
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline),
                          hintText: 'Email',
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                  width: 0, style: BorderStyle.none)),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          return null;
                        },
                      ),

                      // Sized box for spacing
                      const SizedBox(
                        height: 10,
                      ),

                      // Password Field
                      TextFormField(
                        obscureText: _isHidden,
                        controller: passwordController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: GestureDetector(
                              onTap: _togglePasswordView,
                              child: Icon(_isHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off)),
                          hintText: 'Password',
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                  width: 0, style: BorderStyle.none)),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                // Sign up (submit) button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.grey.shade200),
                    ),
                    onPressed: () {
                      // Validate will return true if the form is valid,
                      // or false if the form is invalid
                      if (_formKey.currentState!.validate()) {
                        // Sign the user up (create user account)
                        context
                            .read<AuthenticationService>()
                            .signUp(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim())
                            .then((value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignInPage()),
                                ));
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Password Visibility
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
