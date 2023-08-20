import 'package:get/get.dart';
import '../../domain/entities/supplement.dart';
import '../../domain/repositories/supplements_repository.dart';
import 'auth_controller.dart';

class FavoritesController extends GetxController {
  final SupplementsRepository repository;

  FavoritesController(this.repository);

  final RxBool isLoading = true.obs; // 로딩 상태를 관리하는 속성
  final AuthController authController = Get.find();
  late Stream<List<Supplement>> favoriteSupplements;

  @override
  void onInit() {
    fetchGetLikedSupplements();
    super.onInit();
  }

  Future<void> fetchGetLikedSupplements() async {
    final user = authController.user.value;
    favoriteSupplements = repository.getLikedSupplements(user!);

    // repository.getLikedSupplements(user!).listen((data) {
    //   likedSupplements.addAll(data);
    // });

    isLoading.value = false; // 데이터 바인딩 후, 로딩 상태를 false로 변경

  }
}
