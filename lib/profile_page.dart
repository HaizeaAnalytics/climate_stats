import 'package:climate_stats/app_bar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Navigation bar area
        appBar: appBar('Profile'),
        body: Container(
          child: Column(
            children: const [
              LogoArea(),
              PageInfo(),
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
          Image.asset('../assets/haizea.png', fit: BoxFit.cover),
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
  const PageInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    return Container(
      child: Column(
        children: [
          const Text("Manage Profile",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 54.0,
                color: Colors.white,
              )),
          Text("Last login: " + date.toString()),
        ],
      ),
      width: double.infinity,
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
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

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
              const Text("Account details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 48.0,
                    color: Colors.white,
                  )),
              const Text("Name",
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
                  fillColor: Colors.lightBlue[100],
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

              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  hintText: 'Last name',
                  filled: true,
                  fillColor: Colors.lightBlue[100],
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
                  prefixIcon: const Icon(Icons.person_outline),
                  hintText: 'Phone',
                  filled: true,
                  fillColor: Colors.lightBlue[100],
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

              // save button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid,
                    // or false if the form is invalid
                    if (_formKey.currentState!.validate()) {
                      // submit changes
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
