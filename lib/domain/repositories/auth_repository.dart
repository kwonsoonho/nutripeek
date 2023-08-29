

import '../entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract class AuthRepository {
  Future<User?> signInWithGoogle();

  Future<void> signOut();

  Future<void> updateUserDataIfNeeded();

  Future<User?> getCurrentUser();

  Stream<firebase_auth.User?> onAuthStateChanged();
}
