// ignore_for_file: avoid_print

import 'package:climate_stats/app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// the global attributes used in here, is helpful for story the context that will be
/// used outside of class
const String databaseName = "userInfo";
String userUid = "";
String lastUsername = "";
String lastPassword = "";

/// This class is controll all elements in profile page
/// The stateless widget used in here because this page does not contains any dynamic interation
class ProfilePage extends StatelessWidget {
  //const ProfilePage({Key? key}) : super(key: key);
  User userInfo;
  String lastLoginTime = "";

  /// Iniital the login time and uid, the login time will be displayed in the page
  ProfilePage(this.userInfo) {
    userUid = userInfo.uid.toString();
    lastLoginTime = userInfo.metadata.lastSignInTime!.toLocal().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Navigation bar area
        appBar: TopAppBar("Profit", userInfo),
        body: Container(
          child: Column(
            /// the page has 3 conponents: logo, page info and user info
            children: [
              const LogoArea(),
              PageInfo(lastLoginTime),
              const AccountInfoFields(),
            ],
          ),

          /// for the backgound of page
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("../assets/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ));
  }
}

/*
Logo area
 */
class LogoArea extends StatelessWidget {
  const LogoArea({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          // Image.asset('../assets/haizea.png', fit: BoxFit.cover),
        ],
      ),
      height: 68.0,
      width: double.infinity,
    );
  }
}

/*
Page information
 */
class PageInfo extends StatelessWidget {
  //const PageInfo({Key? key}) : super(key: key);
  String lastLoginTime;
  PageInfo(this.lastLoginTime);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Manage Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 54.0,
              color: Colors.white,
            )),
        Text(
          "Last login: " + lastLoginTime,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

/*
Account Info
 */
class AccountInfoFields extends StatefulWidget {
  const AccountInfoFields({Key? key}) : super(key: key);
  @override
  State<AccountInfoFields> createState() => _AccountInfoFieldsState();
}

class _AccountInfoFieldsState extends State<AccountInfoFields> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Password Visibility
  bool _isHidden = true;

  // update user account in auth
  FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

  // Initialise controllers for text fields, for fetch the current user info
  // from DB
  TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  _AccountInfoFieldsState() {
    FirebaseFirestore.instance
        .collection(databaseName)
        .doc(userUid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        firstNameController.value =
            TextEditingValue(text: documentSnapshot.get("firstName"));
        lastNameController.value =
            TextEditingValue(text: documentSnapshot.get("lastName"));
        passwordController.value =
            TextEditingValue(text: documentSnapshot.get("password"));
        phoneController.value =
            TextEditingValue(text: documentSnapshot.get("phoneNumber"));
        emailController.value =
            TextEditingValue(text: documentSnapshot.get("email"));

        lastUsername = documentSnapshot.get("email");
        lastPassword = documentSnapshot.get("password");
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  // Password Visibility
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: SizedBox(
          width: 450,

          /// user information will display in each widget
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Account details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 48.0,
                    color: Colors.white,
                  )),
              const SizedBox(
                height: 10,
              ),
              const Text("First name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.white,
                  )),

              // Name Field
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  hintText: 'First name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),

              const Text("Last name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.white,
                  )),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  hintText: 'Last name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),

              // Password Field
              const Text("Password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.white,
                  )),
              TextFormField(
                obscureText: _isHidden,
                controller: passwordController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: GestureDetector(
                      onTap: _togglePasswordView,
                      child: Icon(
                          _isHidden ? Icons.visibility : Icons.visibility_off)),
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
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

              // Phone Field
              const Text("Phone",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.white,
                  )),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  hintText: 'Phone',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),

              // Email Field
              const Text("Email",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.white,
                  )),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
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

              // save button
              // the when click the save buttom, the user info will be saved in to database
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate will return true if the form is valid,
                    // or false if the form is invalid
                    if (_formKey.currentState!.validate()) {
                      // submit changes.
                      CollectionReference users =
                          FirebaseFirestore.instance.collection(databaseName);

                      // update the user info to the database, if the info does
                      // not change, it will be saved as the same as the original
                      // here can be optimal, but it does not implement in this semester
                      users
                          .doc(userUid)
                          .update({
                            'firstName': firstNameController.text.trim(),
                            'lastName': lastNameController.text.trim(),
                            'password': passwordController.text.trim(),
                            'phoneNumber': phoneController.text.trim(),
                            'email': emailController.text.trim()
                          })
                          .then((value) => _showDialog(context))
                          .catchError((error) =>
                              print("Failed to update user: $error"));

                      //update email and password in auth page at the same time
                      if (lastUsername != emailController.text.trim() &&
                          lastPassword != passwordController.text.trim()) {
                        currentUser
                            ?.updateEmail(emailController.text.trim())
                            .then((value) => currentUser?.updatePassword(
                                passwordController.text.trim()));
                      } else if (lastUsername != emailController.text.trim()) {
                        currentUser
                            ?.updateEmail(emailController.text.trim())
                            .then((value) => null);
                      } else if (lastPassword !=
                          passwordController.text.trim()) {
                        currentUser
                            ?.updatePassword(passwordController.text.trim());
                      }
                    }
                  },
                  child: const Text("Save details"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// pop the dialog to back the last page
_showDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Account information updated"),
          actions: <Widget>[
            TextButton(
              child: const Text("Back"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}
