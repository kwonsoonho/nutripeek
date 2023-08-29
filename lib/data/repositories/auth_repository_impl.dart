import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nutripeek/domain/entities/user.dart';
import 'package:nutripeek/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore 인스턴스

  @override
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final firebase_auth.AuthCredential credential =
            firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final firebase_auth.UserCredential authResult =
            await _firebaseAuth.signInWithCredential(credential);
        final firebase_auth.User? user = authResult.user;

        final DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user?.uid).get();
        final data = userDoc.data();

        if (user != null) {
          final User appUser = User(
              uid: user.uid,
              email: user.email!,
              displayName: user.displayName!,
              favoriteSupplements: data != null ? List<String>.from(userDoc['favoriteSupplements'] ?? []) : [],
              likedSupplements: data != null ? List<String>.from(userDoc['likedSupplements'] ?? []) : []);

          // Firestore에 사용자 문서 생성 또는 업데이트
          await _firestore.collection('users').doc(user.uid).set(
              {
                'uid': user.uid,
                'email': user.email,
                'displayName': user.displayName,
                'favoriteSupplements': appUser.favoriteSupplements,
                'likedSupplements': appUser.likedSupplements,
                // 기타 필요한 필드 추가
              },
              SetOptions(
                  merge: true)); // merge 옵션을 사용하면 문서가 이미 있으면 업데이트, 없으면 생성됩니다.

          return appUser;
        }
      }
    } catch (error) {
      print(error);
      return null;
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<User?> getCurrentUser() async {
    final firebase_auth.User? user = _firebaseAuth.currentUser;
    if (user != null) {
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      final List<String> favoriteSupplements =
          List<String>.from(userDoc['favoriteSupplements'] ?? []);
      final List<String> likedSupplements =
          List<String>.from(userDoc['likedSupplements'] ?? []);

      return User(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName!,
        favoriteSupplements: favoriteSupplements,
        likedSupplements: likedSupplements,
      );
    }
    return null;
  }

  @override
  Future<void> updateUserDataIfNeeded() async {
    final firebase_auth.User? user = _firebaseAuth.currentUser;
    if (user != null) {
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      final Map<String, dynamic>? data =
          userDoc.data() as Map<String, dynamic>?;

      print("User Document Data: $data"); // 문서 데이터 출력

      if (data != null &&
          (!data.containsKey('favoriteSupplements') ||
              !data.containsKey('likedSupplements'))) {
        print(
            "Initializing favoriteSupplements and likedSupplements"); // 초기화 로그

        await _firestore.collection('users').doc(user.uid).set({
          'favoriteSupplements': [],
          'likedSupplements': [],
        }, SetOptions(merge: true));
      }
    }
  }

  @override
  Stream<firebase_auth.User?> onAuthStateChanged() {
    return _firebaseAuth.authStateChanges();
  }
}
