import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutripeek/presentation/controllers/auth_controller.dart';
import 'package:nutripeek/presentation/views/login_page.dart';

import '../../data/repositories/supplements_repository.dart';
import '../controllers/supplement_info_controller.dart';
import 'SupplementDetailPage.dart';
import 'my_page.dart';

class SupplementInfoPage extends StatelessWidget {
  final controller =
      Get.put(SupplementInfoController(FirebaseSupplementsRepository()));
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(); // 포커스 노드 생성

  SupplementInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplements'),
        actions: [
          IconButton(
              onPressed: () {
                final user = authController.user; // 사용자 정보 가져오기
                if (user != null) {
                  Get.to(() => MyPage(user: user)); // null이 아니면 MyPage로 이동
                } else if (user == null) {
                  Get.offAll(() => const LoginPage());
                }
              },
              icon: const Icon(Icons.person)),
          IconButton(
              onPressed: () async {
                await authController.signOut(); // AuthController 사용하여 로그아웃
                Get.offAll(() => const LoginPage());
              },
              icon: const Icon(Icons.logout))
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
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  // 입력값 초기화 버튼 추가
                  icon: const Icon(Icons.clear),
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
                    return const CircularProgressIndicator(); // 로딩 표시
                  }
                  final supplement = controller.supplements[index];
                  return ListTile(
                    title: Text(supplement.productName),
                    subtitle: Text(supplement.businessName),
                    onTap: () {
                      // onTap 추가
                      final user = authController.user; // 사용자 정보 가져오기
                      if (user != null) {
                        Get.to(() => SupplementDetailPage(
                            supplement: supplement,
                            user: user)); // 상세보기 페이지로 이동
                      } else if (user == null) {
                        Get.offAll(() => const LoginPage());
                      }
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
