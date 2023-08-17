import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutripeek/presentation/controllers/auth_controller.dart';
import 'package:nutripeek/presentation/views/supplement_info_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>(); // 변경된 부분
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
                await authController.signInWithGoogle();
                final user = authController.user; // 사용자 정보 가져오기
                if (user != null) {
                  Get.offAll(SupplementInfoPage());
                }
              },
              child: Text('Sign In with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
