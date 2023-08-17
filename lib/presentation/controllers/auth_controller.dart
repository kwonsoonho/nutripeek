import 'package:get/get.dart';
import 'package:nutripeek/domain/entities/user.dart';
import 'package:nutripeek/domain/usecases/sign_in_with_google.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;
  final SignInWithGoogle _signInWithGoogle;
  final _user = Rxn<User>();

  AuthController(this.authRepository, this._signInWithGoogle); // 생성자 수정

  User? get user => _user.value;

  Future<void> signInWithGoogle() async {
    final user = await _signInWithGoogle();
    print('SignInWithGoogle returned: $user');
    _user.value = user;
  }

  Future<void> signOut() async {
    await authRepository.signOut(); // AuthRepository의 signOut 호출
  }
}