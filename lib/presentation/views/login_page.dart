import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutripeek/presentation/controllers/auth_controller.dart';
import 'package:nutripeek/presentation/views/supplement_info_page.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome! Please sign in with Google.'),
            ElevatedButton(
              onPressed: () async {
                await _authController.signInWithGoogle();
                Get.to(SupplementInfoPage());
              },
              child: Text('Sign In with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
