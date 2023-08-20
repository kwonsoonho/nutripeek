import 'package:get/get.dart';
import 'package:nutripeek/domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../views/bottom_navigation_page.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  final user = Rx<User?>(null);

  Future<void> signInWithGoogle() async {
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        this.user.value = user;
        print('user.uid: ${user.uid}');
        Get.offAll(() => BottomNavigationPage());
      } else {
        Get.snackbar('Login Failed', 'Please try again');
      }
    } catch (e) {
      Get.snackbar('Login Error', e.toString());
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    user.value = null;
  }
}
