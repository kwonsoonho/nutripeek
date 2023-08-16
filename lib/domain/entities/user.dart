import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class User {
  final String? uid;
  final String? displayName;
  final String? email;
  final List<String> favoriteSupplements; // 찜한 영양제의 ID 목록
  final List<String> likedSupplements; // 좋아요한 영양제의 ID 목록

  User({
    required this.uid,
    this.displayName,
    this.email,
    required this.favoriteSupplements,
    required this.likedSupplements,
  });

  static User fromFirebaseUser(firebase_auth.User user) {
    return User(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      favoriteSupplements: [],
      likedSupplements: [],
    );
  }
}
