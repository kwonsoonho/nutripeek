import '../entities/user.dart';

abstract class AuthRepository {
  Future<User?> signInWithGoogle();
  Future<void> signOut();
  Future<void> updateUserDataIfNeeded();
  Future<User?> getCurrentUser();
}
