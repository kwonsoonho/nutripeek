// SupplementDetailPage.dart

import 'package:flutter/material.dart';
import 'package:nutripeek/presentation/views/review_page.dart';
import '../../domain/entities/supplement.dart';

class SupplementDetailPage extends StatefulWidget {
  final Supplement supplement;

  const SupplementDetailPage({super.key, required this.supplement});

  @override
  State<SupplementDetailPage> createState() => _SupplementDetailPageState();
}

class _SupplementDetailPageState extends State<SupplementDetailPage> {

  bool isLiked = false; // 좋아요 상태
  bool isFavorited = false; // 찜하기 상태
  int likeCount = 0;
  int favoriteCount = 0;
  int reviewCount = 0;

  // 초기화 함수에서 Firestore에서 현재 영양제의 상태를 가져옵니다.
  void initState() {
    super.initState();
    // Firestore에서 좋아요, 찜, 리뷰 수를 가져오고, 현재 사용자의 상태를 확인합니다.
  }

  void toggleLike() {
    // Firestore에 좋아요 상태를 업데이트하고, 좋아요 수를 증가/감소시킵니다.
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
  }

  void toggleFavorite() {
    // Firestore에 찜하기 상태를 업데이트하고, 찜하기 수를 증가/감소시킵니다.
    setState(() {
      isFavorited = !isFavorited;
      favoriteCount += isFavorited ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.supplement.productName),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined),
              onPressed: toggleLike,
            ),
            Text('Likes: $likeCount'),
            IconButton(
              icon: Icon(isFavorited ? Icons.favorite : Icons.favorite_border),
              onPressed: toggleFavorite,
            ),
            Text('Favorites: $favoriteCount'),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewPage(supplement: widget.supplement),
                  ),
                );
              },
              child: Text('Reviews: $reviewCount'),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCardSection(
              '일반 정보',
              [
                buildInfo('사업자명', widget.supplement.businessName),
                buildInfo('제품명', widget.supplement.productName),
                buildInfo('산업 유형', widget.supplement.industryType),
                buildInfo('제품 유형', widget.supplement.productType),
              ],
            ),

            buildCardSection(
              '성분 정보',
              [
                buildInfo('캡슐 성분', widget.supplement.capsuleIngredients),
                buildInfoList('기능 성분', widget.supplement.functionalIngredients),
                SizedBox(height: 16),
                buildInfoList('기타 성분', widget.supplement.otherIngredients),
              ],
            ),

            buildCardSection(
              '섭취 및 저장',
              [
                buildInfo('섭취 방법', widget.supplement.intakeMethod),
                buildInfo('섭취 시 주의사항', widget.supplement.cautionWhenTaking),
                buildInfo('저장 방법', widget.supplement.storageMethod),
                buildInfo('유통 기한', widget.supplement.expirationDays),
              ],
            ),

            // 다른 섹션과 정보를 추가로 나열
          ],
        ),
      ),
    );
  }

  Widget buildCardSection(String title, List<Widget> children) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle(title),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildDivider() {
    return Divider(
      thickness: 1,
      color: Colors.grey,
    );
  }

  Widget buildInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget buildInfoList(String title, String value) {
    var valuesList = value.split(',');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...valuesList
                    .map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text('$item'),
                        ))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
