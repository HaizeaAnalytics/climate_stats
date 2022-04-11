import 'package:climate_stats/app_bar.dart';
import 'package:climate_stats/authentication_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Sign in'),
      body: const InputFields(),
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

  // Initialise controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: SizedBox(
          width: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Page Heading
              const Text(
                "Welcome to Haizea Climate Statistics",
                textScaleFactor: 2.5,
              ),
              const SizedBox(
                height: 50,
              ),
              // Email Field
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.lightBlue[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
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
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.lightBlue[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              // Sign in (submit) button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Sign up button
                  ElevatedButton(
                    onPressed: () {
                      // TODO: implement sign up
                    },
                    child: const Text('First time? Sign up!'),
                  ),
                  // Forgot password button
                  ElevatedButton(
                      onPressed: () {
                        // TODO: implement forgot password
                      },
                      child: const Text('Forgot Password?'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
