import 'package:get/get.dart';
import 'package:nutripeek/data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  Future<void> signInWithGoogle() async {
    final user = await _authRepository.signInWithGoogle();
    if (user != null) {
      print('로그인 성공');
      // 로그인 성공 로직
    } else {
      // 로그인 실패 로직
    }
  }
}
