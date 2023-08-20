// firebase_supplements_repository.dart

import '../entities/supplement.dart';
import '../entities/user.dart';

abstract class SupplementsRepository {
  Stream<List<Supplement>> getNextSupplements();
  Stream<List<Supplement>> getLikedSupplements(User user);
  Stream<List<Supplement>> searchSupplements(String field, String query);

}
