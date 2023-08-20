import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutripeek/data/repositories/firebase_supplements_repository.dart';
import 'package:nutripeek/presentation/controllers/auth_controller.dart';
import 'package:nutripeek/presentation/views/supplement_detail_page.dart';

import '../../domain/entities/supplement.dart';
import '../controllers/favorites_controller.dart';

class FavoritesPage extends StatelessWidget {
  final AuthController authController = Get.find();
  final controller =
      Get.put(FavoritesController(FirebaseSupplementsRepository()));

  @override
  Widget build(BuildContext context) {
    final user = authController.user.value;

    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('찜 목록'),
    //   ),
    //   body: Column(
    //     children: [
    //       Text(user?.uid ?? 'null'),
    //       Text(controller.likedSupplements.length.toString()),
    //     ],
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        title: const Text('찜 목록'),
      ),
      body: StreamBuilder<List<Supplement>>(
        stream: controller.favoriteSupplements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No favorites found.');
          }

          final supplements = snapshot.data!;
          return ListView.builder(
            itemCount: supplements.length,
            itemBuilder: (context, index) {
              final supplement = supplements[index];
              return ListTile(
                title: Text(supplement.productName),
                subtitle: Text(supplement.productType),
                onTap: () {
                  if (user != null) {
                    Get.to(() => SupplementDetailPage(
                        supplement: supplement, user: user)); // 상세보기 페이지로 이동
                  } else {
                    Get.dialog(AlertDialog(
                      title: const Text('로그인 필요'),
                      content: const Text('로그인이 필요한 서비스입니다.'),
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
          );
        },
      ),
    );

    // return GetBuilder<FavoritesController>(
    //   builder: (controller) {
    //     if (controller.isLoading.value) {
    //       return const Center(child: CircularProgressIndicator());
    //     }
    //
    //     return ListView.builder(
    //       itemCount: controller.likedSupplements.length,
    //       itemBuilder: (context, index) {
    //         final Supplement supplement = controller.likedSupplements[index];
    //         return ListTile(
    //           title: Text(supplement.productName),
    //           subtitle: Text(supplement.productType),
    //           onTap: () {
    //             if (user != null) {
    //               Get.to(() => SupplementDetailPage(
    //                   supplement: supplement, user: user)); // 상세보기 페이지로 이동
    //             } else {
    //               Get.dialog(AlertDialog(
    //                 title: Text('로그인 필요'),
    //                 content: Text('로그인이 필요한 서비스입니다.'),
    //                 actions: [
    //                   TextButton(
    //                       onPressed: () {
    //                         Get.back();
    //                       },
    //                       child: const Text('확인'))
    //                 ],
    //               ));
    //             }
    //           },
    //         );
    //       },
    //     );
    //   },
    // );
  }
}
