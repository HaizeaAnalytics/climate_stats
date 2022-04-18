import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EmailField(),
    );
  }
}

class EmailField extends StatefulWidget {
  const EmailField({Key? key}) : super(key: key);

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Initialise controller for email field
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
                // Instruction text
                const Text("Enter your email to receive a password reset link",
                    textScaleFactor: 2.5,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),

                const SizedBox(
                  height: 50,
                ),

                // Text field for user email address
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

                  // If an email address is not provided, prompt user
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

                // Reset password (submit) button
                ElevatedButton(
                  onPressed: () async {
                    // Get email address from field
                    String emailAddress = emailController.text.trim();

                    // Validate email and ensure that email has an
                    // associated user account.
                    // If so, then send a password reset email and return user
                    // to sign_in_page.
                    if (_formKey.currentState!.validate() &&
                        await emailInUse(email: emailAddress)) {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: emailAddress)
                          .then((value) => Navigator.of(context).pop());
                    }
                  },
                  child: const Text("Reset Password"),
                ),

                const SizedBox(
                  height: 16,
                ),

                // Back button
                // Return user to previous (sign-in) page
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Back"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Return a bool
  // true if the given email has an associated user account,
  // false otherwise
  Future<bool> emailInUse({required String email}) async {
    try {
      final list =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (list.isNotEmpty) {
        return true;
      }
      showDialog(
          context: context,
          builder: (BuildContext context) => const AlertDialog(
                title: Text('Account Not Found'),
                content: Text(
                    'Oops! No user accounts were found for that email address. \nPlease check the spelling and try again.'),
              ));
      return false;
    } on FirebaseAuthException {
      showDialog(
          context: context,
          builder: (BuildContext context) => const AlertDialog(
                title: Text('Invalid Email Address'),
                content: Text('Please check the spelling and try again.'),
              ));
      return false;
    }
  }
}
