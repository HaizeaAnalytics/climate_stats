import 'package:climate_stats/authentication_service.dart';
import 'package:climate_stats/reset_password.dart';
import 'package:climate_stats/sign_up_page.dart';
import 'package:climate_stats/reusable/input_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

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
      child: Form(
        key: _formKey,
        child: Center(
          child: SizedBox(
            width: 800,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Logo
                Image.asset("haizea.png", scale: 3.2),
                const SizedBox(
                  height: 50,
                ),
                const Text("Welcome to Haizea Climate Statistics.",
                    textScaleFactor: 2.5,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  height: 50,
                ),
                // Email Field
                SizedBox(
                  width: 500,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline),
                          hintText: 'Email',
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: InputStyle,
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          return null;
                        },
                      ),
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
                          border: InputStyle,
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
                // Sign in (submit) button
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
                        // Sign the user in
                        context.read<AuthenticationService>().signIn(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim());
                      }
                    },
                    child: const Text('Log in'),
                  ),
                ),

                // Other buttons
                Container(
                  width: 300,
                  color: Colors.black.withAlpha(200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Sign up button
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()),
                          );
                        },
                        child: const Text('First time? Sign up!',
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                            )),
                      ),

                      // Forgot password button
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ResetPassword()),
                          );
                        },
                        child: const Text('Forgot Password?',
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                            )),
                      ),
                    ],
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
