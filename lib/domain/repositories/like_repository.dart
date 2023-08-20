
import 'package:nutripeek/domain/entities/supplement.dart';
import 'package:nutripeek/domain/entities/user.dart';

abstract class LikeRepository {
  Future<bool> isLikedByUser(String supplementId, String userId);
  Future<void> toggleLike(String supplementId, String userId);
  Future<int> getLikesCount(String supplementId);

  Future<bool> isFavoritedByUser(String supplementId, String userId);
  Future<void> toggleFavorite(String supplementId, String userId);
  Future<int> getFavoritesCount(String supplementId);
  // Stream<List<Supplement>> getLikedSupplements(User user);


}
