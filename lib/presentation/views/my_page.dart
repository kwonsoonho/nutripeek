import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutripeek/domain/entities/user.dart';
import 'package:nutripeek/presentation/views/login_page.dart';

import '../../domain/repositories/auth_repository.dart';

class MyPage extends StatelessWidget {
  final User user;
  final AuthRepository authRepository; // AuthRepository를 추가

  const MyPage(
      {super.key,
      required this.user,
      required this.authRepository}); // 생성자에 AuthRepository를 전달

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authRepository.signOut(); // 로그아웃을 호출
              Get.offAll(LoginPage());
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.account_circle, size: 100), // 프로필 이미지가 필요하면 이미지 위젯으로 변경
            SizedBox(height: 16),
            Text('UID: ${user.uid}', style: TextStyle(fontSize: 18)),
            Text('Name: ${user.displayName ?? "N/A"}',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('Email: ${user.email ?? "N/A"}',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
