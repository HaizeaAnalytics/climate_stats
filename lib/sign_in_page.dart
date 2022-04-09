import 'package:climate_stats/app_bar.dart';
import 'package:climate_stats/authentication_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar('Sign in'),
        body: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AuthenticationService>().signIn(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim());
              },
              child: const Text("Sign in"),
            )
          ],
        ));
  }
}
