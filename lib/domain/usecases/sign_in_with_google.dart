import 'package:nutripeek/domain/entities/user.dart';
import 'package:nutripeek/domain/repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository authRepository;

  SignInWithGoogle(this.authRepository);

  Future<User?> call() => authRepository.signInWithGoogle();
}
