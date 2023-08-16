// SupplementDetailPage.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutripeek/presentation/views/review_page.dart';
import '../../domain/entities/supplement.dart';
import '../../domain/entities/user.dart';

class SupplementDetailPage extends StatefulWidget {
  final Supplement supplement;
  final User user; // 사용자 객체를 추가

  const SupplementDetailPage(
      {super.key, required this.supplement, required this.user});

  @override
  State<SupplementDetailPage> createState() => _SupplementDetailPageState();
}

class _SupplementDetailPageState extends State<SupplementDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.supplement.productName),
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
            buildActionSection(),
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

  Widget buildActionSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildLikeButton(),
        buildFavoriteButton(),
        buildReviewButton(),
      ],
    );
  }

  Widget buildLikeButton() {
    final isLiked = widget.supplement.likes[widget.user.uid] ?? false;
    final likeCount = widget.supplement.likes.length;
    return Row(
      children: [
        IconButton(
          icon: Icon(isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt),
          onPressed: () {
            // 로직 추가
          },
        ),
        Text('$likeCount'),
      ],
    );
  }

  Widget buildFavoriteButton() {
    final isFavorite = widget.supplement.favorites[widget.user.uid] ?? false;
    return IconButton(
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      onPressed: () {
        // 로직 추가
      },
    );
  }

  Widget buildReviewButton() {
    // 리뷰 수를 가져와서 보여주도록 코드 수정
    return IconButton(
      icon: const Icon(Icons.rate_review),
      onPressed: () {
        // 리뷰 페이지로 넘어가기 전에 리뷰 리스트 받아와서 전달

        Get.to(const ReviewPage());
      },
    );
  }
}
