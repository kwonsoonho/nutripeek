import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserPreferences {
  final List<String> favoriteSupplements; // 찜한 영양제 ID 목록
  final List<String> likedSupplements; // 좋아요한 영양제 ID 목록
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance; // FirebaseAuth 인스턴스
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore 인스턴스

  UserPreferences({
    required this.favoriteSupplements,
    required this.likedSupplements,
  });

  // 기타 도메인 로직, 예: 찜한 영양제 추가/제거, 좋아요한 영양제 추가/제거 등

  Future<void> updateUserDataIfNeeded() async {
    final firebase_auth.User? user = _firebaseAuth.currentUser;
    if (user != null) {
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      // Firestore에 favoriteSupplements, likedSupplements 필드가 없는 경우 초기화
      if (userDoc['favoriteSupplements'] == null ||
          userDoc['likedSupplements'] == null) {
        await _firestore.collection('users').doc(user.uid).set({
          'favoriteSupplements': [], // 빈 배열로 초기화
          'likedSupplements': [], // 빈 배열로 초기화
        }, SetOptions(merge: true)); // merge 옵션을 사용하여 기존 문서와 병합
      }
    }
  }
}
