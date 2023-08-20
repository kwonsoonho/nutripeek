import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutripeek/presentation/controllers/auth_controller.dart';
import 'package:nutripeek/presentation/views/login_page.dart';
import 'package:nutripeek/presentation/views/search_page.dart';

import '../../data/repositories/firebase_supplements_repository.dart';
import '../controllers/supplement_info_controller.dart';
import 'supplement_detail_page.dart';
import 'my_page.dart';

class SupplementInfoPage extends StatelessWidget {
  final controller =
      Get.put(SupplementInfoController(FirebaseSupplementsRepository()));
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(); // 포커스 노드 생성
  final AuthController authController = Get.find();

  SupplementInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = authController.user.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplements'),
        actions: [
          IconButton(
              onPressed: () {
                if (user != null) {
                  Get.to(() => MyPage(user: user)); // null이 아니면 MyPage로 이동
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
              icon: const Icon(Icons.person)),
          IconButton(
              onPressed: () async {
                await authController.signOut(); // AuthController 사용하여 로그아웃
                Get.offAll(() => LoginPage());
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     controller: _searchController, // 컨트롤러 연결
          //     focusNode: _searchFocusNode, // 포커스 노드 연결
          //     onChanged: (query) {
          //       controller.searchSupplements(query);
          //     },
          //     decoration: InputDecoration(
          //       labelText: 'Search',
          //       border: const OutlineInputBorder(),
          //       suffixIcon: IconButton(
          //         // 입력값 초기화 버튼 추가
          //         icon: const Icon(Icons.clear),
          //         onPressed: () {
          //           _searchController.clear(); // 입력값 초기화
          //           controller.resetSearch(); // 리스트 초기화
          //           _searchFocusNode.unfocus(); // 포커스 제거
          //         },
          //       ),
          //     ),
          //   ),
          // ),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          Get.to(() => SearchPage());
        },
      ),
    );
  }
}
