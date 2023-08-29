import 'package:get/get.dart';
import 'package:nutripeek/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/repositories/auth_repository.dart';
import '../views/bottom_navigation_page.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  final user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    _initFromSharedPreferences();
    _authRepository.onAuthStateChanged().listen((firebase_auth.User? firebaseUser) {
      if (firebaseUser != null) {
        user.value = User.fromFirebaseUser(firebaseUser);
        _saveUserTokenToSharedPreferences(firebaseUser.uid);
      } else {
        user.value = null;
        _removeUserTokenFromSharedPreferences();
      }
    });
  }

  Future<void> _initFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    if (userToken != null) {
      // Implement logic to validate the token and update the user info
    }
  }

  Future<void> _saveUserTokenToSharedPreferences(String userToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userToken', userToken);
  }

  Future<void> _removeUserTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userToken');
  }

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
