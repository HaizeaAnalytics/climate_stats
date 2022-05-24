// ignore_for_file: avoid_print

import 'authentication_service.dart';
import 'reusable/input_style.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

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

  // Password Validation
  bool _isValid = false;

  // Initialise controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

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
                  textScaleFactor: 1.5,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Sized box (defines width of child text fields)
                SizedBox(
                  width: 500,
                  child: Column(
                    children: [
                      //First name field
                      TextFormField(
                        controller: firstNameController,
                        decoration: InputDecoration(
                          hintText: 'First Name',
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: InputStyle,
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Last name field
                      TextFormField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          hintText: 'Last Name',
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: InputStyle,
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // Phone number field
                      TextFormField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        maxLength: 10,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.contact_phone),
                            hintText: 'Phone Number',
                            filled: true,
                            fillColor: Colors.grey[300],
                            border: InputStyle,
                            counterText: ''),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
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
                      // Sized box for spacing
                      const SizedBox(
                        height: 30,
                      ),
                      FlutterPwValidator(
                        controller: passwordController,
                        minLength: 6,
                        uppercaseCharCount: 1,
                        specialCharCount: 1,
                        width: 400,
                        height: 150,
                        onSuccess: () {
                          print("MATCHED");
                          _setValid(true);
                        },
                        onFail: () {
                          print("NOT MATCHED");
                          _setValid(false);
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
                    onPressed: () => {
                      // Validate form and password
                      if (_formKey.currentState!.validate() && _isValid)
                        {
                          // Sign the user up (create user account)
                          context
                              .read<AuthenticationService>()
                              .signUp(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  firstName: firstNameController.text.trim(),
                                  lastName: lastNameController.text.trim(),
                                  phoneNumber:
                                      phoneNumberController.text.trim())
                              .then((value) => Navigator.of(context).pop())
                        }
                      else
                        {null}
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

  // Set Password Validity
  void _setValid(bool set) {
    setState(() {
      _isValid = set;
    });
  }
}
