import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: emailField(),
    );
  }
}

class emailField extends StatefulWidget {
  const emailField({Key? key}) : super(key: key);

  @override
  State<emailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<emailField> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Initialise controllers for email field
  final TextEditingController emailController = TextEditingController();

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
            width: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid,
                    // or false if the form is invalid
                    if (_formKey.currentState!.validate()) {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(
                              email: emailController.text.trim())
                          .then((value) => Navigator.of(context).pop());
                    }
                  },
                  child: const Text("Reset Password"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
