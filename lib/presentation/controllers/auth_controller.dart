import 'package:get/get.dart';
import 'package:nutripeek/domain/entities/user.dart';
import 'package:nutripeek/domain/usecases/sign_in_with_google.dart';

class AuthController extends GetxController {
  final SignInWithGoogle _signInWithGoogle;

  AuthController(this._signInWithGoogle);

  final _user = Rxn<User>();

  User? get user => _user.value;

  Future<void> signInWithGoogle() async {
    final user = await _signInWithGoogle();
    _user.value = user;
    print('user info : $_user');
  }

}
