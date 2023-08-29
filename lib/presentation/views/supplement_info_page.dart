import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutripeek/presentation/controllers/auth_controller.dart';
import 'package:nutripeek/presentation/views/login_page.dart';

import '../../data/repositories/firebase_supplements_repository.dart';
import '../controllers/supplement_info_controller.dart';
import 'supplement_detail_page.dart';
import 'my_page.dart';

class SupplementInfoPage extends StatelessWidget {
  final controller =
      Get.put(SupplementInfoController(FirebaseSupplementsRepository()));
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
          if (user != null) {
            // Get.to(() => SupplementSearchPage());
            // Get.to(() => SupplementSearchPage(user : user));

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
      ),
    );
  }
}
