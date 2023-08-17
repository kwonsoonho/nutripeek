import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:nutripeek/data/repositories/auth_repository_impl.dart';
import 'package:nutripeek/domain/usecases/sign_in_with_google.dart';
import 'package:nutripeek/presentation/bindings/app_bindings.dart';
import 'package:nutripeek/presentation/controllers/auth_controller.dart';
import 'package:nutripeek/presentation/views/login_page.dart';
import 'package:nutripeek/presentation/views/supplement_info_page.dart';
import 'domain/repositories/auth_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBindings(),
      home: FutureBuilder(
        future: () async {
          // final authRepository = Get.find<AuthRepository>();
          // await authRepository.updateUserDataIfNeeded();
          return FirebaseAuth.instance.currentUser;
        }(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return SupplementInfoPage(); // 로그인 상태일 때
          } else {
            return LoginPage(); // 로그아웃 상태일 때
          }
        },
      ),
    );
  }
}
