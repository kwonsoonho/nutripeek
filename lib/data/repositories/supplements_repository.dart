import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutripeek/domain/entities/user.dart';

import '../../domain/entities/supplement.dart';

abstract class SupplementsRepository {
  Stream<List<Supplement>> getNextSupplements();
}

class FirebaseSupplementsRepository implements SupplementsRepository {
  QueryDocumentSnapshot? lastDocument;
  int documentLimit = 30;

  @override
  Stream<List<Supplement>> getNextSupplements() {
    Query query = FirebaseFirestore.instance
        .collection('supplements')
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
}
