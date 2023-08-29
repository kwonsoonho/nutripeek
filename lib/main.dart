
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:nutripeek/presentation/bindings/app_bindings.dart';
import 'package:nutripeek/presentation/controllers/auth_controller.dart';
import 'package:nutripeek/presentation/views/bottom_navigation_page.dart';
import 'package:nutripeek/presentation/views/login_page.dart';
import 'package:nutripeek/utils/etc_function.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  EtcFunction.outputProjectStructure('/Users/soon/IdeaProjects/nutripeek/lib');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBindings(),
      home: GetBuilder<AuthController>(
        builder: (authController) {
          return authController.user.value != null
              ? BottomNavigationPage() // 로그인 성공 시 바텀 네비게이션 페이지로 이동
              : LoginPage();
        },
      ),
    );
  }
}
