import 'package:get/get.dart';

import '../../domain/entities/supplement.dart';
import '../../domain/repositories/supplements_repository.dart';

class SupplementSearchController extends GetxController {
  final searchSupplements = RxList<Supplement>();

  final SupplementsRepository repository;
  SupplementSearchController(this.repository);

  @override
  void onInit() {
    searchSupplements.clear();
    super.onInit();
  }

  void getSearchSupplements(String query) {
    if (query.isEmpty) {
      searchSupplements.clear();
      return;
    }

    repository.searchSupplements('productName', query).listen((newSupplements) {
      searchSupplements.assignAll(newSupplements);
    });

    print('searchSupplements: ${searchSupplements.length}');
  }
}
