import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutripeek/presentation/controllers/auth_controller.dart';
import 'package:nutripeek/presentation/views/supplement_detail_page.dart';
import '../../data/repositories/firebase_supplements_repository.dart';
import '../controllers/supplement_search_controller.dart';

class SearchPage extends StatelessWidget {
  final controller =
      Get.put(SupplementSearchController(FirebaseSupplementsRepository()));
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(); // 포커스 노드 생성
  final AuthController authController = Get.find();

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = authController.user.value;
    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController, // 컨트롤러 연결
              focusNode: _searchFocusNode, // 포커스 노드 연결
              onChanged: (query) {
                controller.getSearchSupplements(query);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  // 입력값 초기화 버튼 추가
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear(); // 입력값 초기화
                    _searchFocusNode.unfocus(); // 포커스 제거
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.searchSupplements.length,
                itemBuilder: (context, index) {
                  final supplement = controller.searchSupplements[index];
                  return ListTile(
                    title: Text(supplement.productName),
                    subtitle: Text(supplement.businessName),
                    onTap: () {
                      if (user != null) {
                        Get.to(() => SupplementDetailPage(
                            supplement: supplement,
                            user: user)); // 상세보기 페이지로 이동
                      } else {
                        Get.dialog(AlertDialog(
                          title: Text('로그인 필요'),
                          content: Text('로그인이 필요한 서비스입니다.'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text('확인'))
                          ],
                        ));
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
