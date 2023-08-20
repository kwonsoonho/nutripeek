import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/supplement.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/supplements_repository.dart';

class FirebaseSupplementsRepository implements SupplementsRepository {
  QueryDocumentSnapshot? lastDocument;
  int documentLimit = 30;

  final _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<Supplement>> getNextSupplements() {
    var collection = _firestore.collection('supplements');
    Query query = collection
        // .orderBy('some_field') // 정렬 기준 필드
        .limit(documentLimit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    return query.snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs[snapshot.docs.length - 1];
      }
      return snapshot.docs.map((doc) => Supplement.fromFirestore(doc)).toList();
    });
  }

  @override
  Stream<List<Supplement>> searchSupplements(String field, String query) {
    return _firestore
        .collection('supplements')
        .limit(documentLimit)
        .where(field, isEqualTo: query)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Supplement.fromFirestore(doc))
            .toList());
  }

  @override
  Stream<List<Supplement>> getLikedSupplements(User user) {
    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .asyncMap((snapshot) async {
      List<String> favoriteSupplementsIds =
          List<String>.from(snapshot.data()?['favoriteSupplements'] ?? []);
      List<Supplement> favoriteSupplements = [];
      for (String supplementId in favoriteSupplementsIds) {
        DocumentSnapshot supplementSnapshot =
            await _firestore.collection('supplements').doc(supplementId).get();
        favoriteSupplements.add(Supplement.fromFirestore(supplementSnapshot));
      }
      return favoriteSupplements;
    });
  }
}
