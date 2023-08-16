import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/supplements_repository.dart';
import '../../domain/usecases/get_current_user.dart';
import '../controllers/supplement_info_controller.dart';
import 'SupplementDetailPage.dart';
import 'my_page.dart';

class SupplementInfoPage extends StatelessWidget {
  final controller =
      Get.put(SupplementInfoController(FirebaseSupplementsRepository()));
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(); // 포커스 노드 생성
  final authRepository = AuthRepositoryImpl(); // AuthRepository 구현체를 생성



  SupplementInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supplements'),
        actions: [
          IconButton(
              onPressed: () async {
                final getCurrentUser = GetCurrentUser(AuthRepositoryImpl());
                final user = await getCurrentUser.call();
                if (user != null) {
                  Get.to(MyPage(user: user, authRepository: authRepository,));
                }
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController, // 컨트롤러 연결
              focusNode: _searchFocusNode, // 포커스 노드 연결
              onChanged: (query) {
                controller.searchSupplements(query);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  // 입력값 초기화 버튼 추가
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear(); // 입력값 초기화
                    controller.resetSearch(); // 리스트 초기화
                    _searchFocusNode.unfocus(); // 포커스 제거

                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.supplements.length,
                itemBuilder: (context, index) {
                  if (index == controller.supplements.length - 1) {
                    controller.fetchNextSupplements();
                    return CircularProgressIndicator(); // 로딩 표시
                  }
                  final supplement = controller.supplements[index];
                  return ListTile(
                    title: Text(supplement.productName),
                    subtitle: Text(supplement.businessName),
                    onTap: () { // onTap 추가
                      Get.to(SupplementDetailPage(supplement: supplement)); // 상세보기 페이지로 이동
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
