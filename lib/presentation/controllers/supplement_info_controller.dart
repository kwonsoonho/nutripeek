import 'package:get/get.dart';

import '../../domain/entities/supplement.dart';
import '../../data/repositories/supplements_repository.dart';

class SupplementInfoController extends GetxController {
  final supplements = RxList<Supplement>();

  final SupplementsRepository repository;
  SupplementInfoController(this.repository);

  @override
  void onInit() { // 초기 데이터 불러오기
    fetchNextSupplements();
    super.onInit();
  }

  final allSupplements = RxList<Supplement>([]); // 전체 영양제 목록 저장

  void searchSupplements(String query) {
    if (query.isEmpty) {
      supplements.assignAll(allSupplements);
      return;
    }

    final results = allSupplements.where((supplement) =>
    supplement.productName.toLowerCase().contains(query.toLowerCase()) ||
        supplement.businessName.toLowerCase().contains(query.toLowerCase()));

    supplements.assignAll(results);
  }

  void fetchNextSupplements() {
    repository.getNextSupplements().listen((newSupplements) {
      allSupplements.addAll(newSupplements); // 모든 영양제 목록에 추가
      supplements.assignAll(allSupplements); // 현재 보이는 목록에 추가
    });
  }

  // 초기화 메서드
  void resetSearch() {
    supplements.assignAll(allSupplements);
  }
}
