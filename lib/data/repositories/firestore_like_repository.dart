// data/repositories/firestore_like_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/like_repository.dart';

class FirestoreLikeRepository implements LikeRepository {
  final FirebaseFirestore firestore;

  FirestoreLikeRepository(this.firestore);

  @override
  Future<bool> isFavoritedByUser(String supplementId, String userId) async {
    final userDoc = await firestore.collection('users').doc(userId).get();
    final List<String>? favoriteSupplements =
        userDoc['favoriteSupplements'].cast<String>();
    return favoriteSupplements != null &&
        favoriteSupplements.contains(supplementId);
  }

  @override
  Future<void> toggleFavorite(String supplementId, String userId) async {
    final supplementRef = firestore.collection('supplements').doc(supplementId);
    final userRef = firestore.collection('users').doc(userId);

    final isLiked = await isFavoritedByUser(supplementId, userId);

    return firestore.runTransaction((transaction) async {
      final supplementSnapshot = await transaction.get(supplementRef);
      final userSnapshot = await transaction.get(userRef);

      // likesCount 필드가 없으면 0으로 설정
      final favoritesCount = supplementSnapshot.get('favoritesCount') ?? 0;

      // Toggle the like state
      if (isLiked) {
        transaction.update(supplementRef, {'favoritesCount': favoritesCount - 1});
        transaction.update(userRef, {
          'favoriteSupplements': FieldValue.arrayRemove([supplementId])
        });
      } else {
        transaction.update(supplementRef, {'favoritesCount': favoritesCount + 1});
        transaction.update(userRef, {
          'favoriteSupplements': FieldValue.arrayUnion([supplementId])
        });
      }
    });
  }

  @override
  Future<bool> isLikedByUser(String supplementId, String userId) async {
    final userDoc = await firestore.collection('users').doc(userId).get();
    final List<String>? likedSupplements =
        userDoc['likedSupplements'].cast<String>();
    return likedSupplements != null && likedSupplements.contains(supplementId);
  }

  @override
  Future<void> toggleLike(String supplementId, String userId) async {
    final supplementRef = firestore.collection('supplements').doc(supplementId);
    final userRef = firestore.collection('users').doc(userId);

    // Check if the user has already liked the supplement
    final isLiked = await isLikedByUser(supplementId, userId);

    return firestore.runTransaction((transaction) async {
      final supplementSnapshot = await transaction.get(supplementRef);
      final userSnapshot = await transaction.get(userRef);

      // likesCount 필드가 없으면 0으로 설정
      final likesCount = supplementSnapshot.get('likesCount') ?? 0;
      // final likedSupplements = userSnapshot['likedSupplements'] as List<String>? ?? [];

      // Toggle the like state
      if (isLiked) {
        transaction.update(supplementRef, {'likesCount': likesCount - 1});
        transaction.update(userRef, {
          'likedSupplements': FieldValue.arrayRemove([supplementId])
        });
      } else {
        transaction.update(supplementRef, {'likesCount': likesCount + 1});
        transaction.update(userRef, {
          'likedSupplements': FieldValue.arrayUnion([supplementId])
        });
      }
    });
  }

  Future<int> _getCount(String supplementId, String fieldName) async {
    final snapshot = await firestore.collection('supplements').doc(supplementId).get();

    if (snapshot.exists) {
      final count = snapshot.data()?[fieldName];
      if (count != null) {
        return count;
      } else {
        // 필드가 없으면 생성하고 기본 값으로 0을 할당
        await firestore.collection('supplements').doc(supplementId).set(
          {fieldName: 0},
          SetOptions(merge: true), // 기존의 데이터와 병합
        );
        return 0;
      }
    } else {
      return 0;
    }
  }

  @override
  Future<int> getFavoritesCount(String supplementId) async {
    return _getCount(supplementId, 'favoritesCount');
  }

  @override
  Future<int> getLikesCount(String supplementId) async {
    return _getCount(supplementId, 'likesCount');
  }
}
