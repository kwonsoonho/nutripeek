import 'package:get/get.dart';
import 'package:nutripeek/domain/repositories/auth_repository.dart';
import 'package:nutripeek/domain/usecases/sign_in_with_google.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/firebase_supplements_repository.dart';
import '../controllers/auth_controller.dart'; // FirebaseSupplementsRepository가 있는 파일 import

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInWithGoogle>(
        () => SignInWithGoogle(Get.find<AuthRepository>()),
        fenix: true); // AuthRepository 인자를 넘김
    Get.lazyPut<SupplementsRepository>(() => FirebaseSupplementsRepository(),
        fenix: true);
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(Get.find(), Get.find()),
        fenix: true);
    // 다른 의존성들도 여기에 추가
  }
}
