// supplements_repository.dart

import '../entities/supplement.dart';
import '../entities/user.dart';

abstract class SupplementsRepository {
  Stream<List<Supplement>> getNextSupplements();
}
