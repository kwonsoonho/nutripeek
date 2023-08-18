// firebase_supplements_repository.dart

import '../entities/supplement.dart';

abstract class SupplementsRepository {
  Stream<List<Supplement>> getNextSupplements();
}
