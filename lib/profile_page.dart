import 'package:climate_stats/app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String databaseName = "userInfo";
String userEmail = "";

class ProfilePage extends StatelessWidget {
  //const ProfilePage({Key? key}) : super(key: key);
  User userInfo;
  String lastLoginTime = "";
  ProfilePage(this.userInfo) {
    userEmail = userInfo.email.toString();
    lastLoginTime = userInfo.metadata.lastSignInTime!.toLocal().toString();
    print(lastLoginTime);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Navigation bar area
        appBar: new TopAppBar("Profit", userInfo),
        body: Container(
          child: Column(
            children: [
              LogoArea(),
              PageInfo(this.lastLoginTime),
              AccountInfoFields(),
            ],
          ),
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
    return Container(
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
    return Container(
      child: Column(
        children: [
          const Text("Manage Profile",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 54.0,
                color: Colors.white,
              )),
          Text(
            "Last login: " + lastLoginTime,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
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

  // Initialise controllers for text fields
  TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  _AccountInfoFieldsState() {
    FirebaseFirestore.instance
        .collection(databaseName)
        .doc(userEmail)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        firstNameController.value =
            TextEditingValue(text: documentSnapshot.get("firstname"));
        lastNameController.value =
            TextEditingValue(text: documentSnapshot.get("lastname"));
        passwordController.value =
            TextEditingValue(text: documentSnapshot.get("password"));
        phoneController.value =
            TextEditingValue(text: documentSnapshot.get("phone"));
        emailController.value =
            TextEditingValue(text: documentSnapshot.get("email"));
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: SizedBox(
          width: 450,
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
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid,
                    // or false if the form is invalid
                    if (_formKey.currentState!.validate()) {
                      // submit changes.
                      CollectionReference users =
                          FirebaseFirestore.instance.collection(databaseName);

                      //Future<void> updateUser() {
                      users
                          .doc(userEmail)
                          .update({
                            'firstname': firstNameController.text.trim(),
                            'lastname': lastNameController.text.trim(),
                            'password': passwordController.text.trim(),
                            'phone': phoneController.text.trim(),
                            'email': emailController.text.trim()
                          })
                          .then((value) => _showDialog(context))
                          .catchError((error) =>
                              print("Failed to update user: $error"));
                      //}
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

_showDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Account information updated"),
          actions: <Widget>[
            FlatButton(
              child: const Text("Back"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}
