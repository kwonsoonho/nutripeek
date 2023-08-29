import 'package:get/get.dart';
import 'package:nutripeek/domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/firebase_supplements_repository.dart';
import '../../domain/repositories/supplements_repository.dart';
import '../controllers/auth_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(Get.find()), fenix: true);
    Get.lazyPut<SupplementsRepository>(() => FirebaseSupplementsRepository(),
        fenix: true);

  }
}
