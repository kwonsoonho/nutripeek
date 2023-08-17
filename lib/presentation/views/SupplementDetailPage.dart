// SupplementDetailPage.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutripeek/presentation/views/review_page.dart';
import '../../data/repositories/firestore_like_repository.dart';
import '../../domain/entities/supplement.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/like_repository.dart';

class SupplementDetailPage extends StatefulWidget {
  final Supplement supplement;
  final User user;

  const SupplementDetailPage(
      {super.key, required this.supplement, required this.user});

  @override
  State<SupplementDetailPage> createState() => _SupplementDetailPageState();
}

class _SupplementDetailPageState extends State<SupplementDetailPage> {
  // final SupplementsRepository supplementsRepository = Get.find(); // DI
  final LikeRepository likeRepository =
      Get.put(FirestoreLikeRepository(FirebaseFirestore.instance)); // DI

  bool? isLiked; // null 허용
  bool? isFavorited;

  int? likesCount; // null 허용
  int? favoritesCount;

  @override
  void initState() {
    super.initState();
    _initializeLikeState();
    _initializeFavoriteState(); // 찜하기 상태 초기화
  }

  Future<void> _initializeFavoriteState() async {
    isFavorited = await likeRepository.isFavoritedByUser(
        widget.supplement.productReportNo, widget.user.uid!);

    favoritesCount = await likeRepository
        .getFavoritesCount(widget.supplement.productReportNo);
    setState(() {
      isFavorited = isFavorited;
      favoritesCount = favoritesCount;
    }); // 상태 업데이트
  }

  Future<void> _initializeLikeState() async {
    isLiked = await likeRepository.isLikedByUser(
        widget.supplement.productReportNo, widget.user.uid!);

    likesCount =
        await likeRepository.getLikesCount(widget.supplement.productReportNo);

    setState(() {
      likesCount = likesCount;
      isLiked = isLiked;
    }); // 상태 업데이트
  }

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
                const SizedBox(height: 16),
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
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildDivider() {
    return const Divider(
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
            child: Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
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
            child: Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
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
    // isLiked가 null이면 아이콘을 표시하지 않음
    if (isLiked == null) return Container();

    return Row(
      children: [
        IconButton(
          icon: isLiked!
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border),
          onPressed: () async {
            await likeRepository.toggleLike(
                widget.supplement.productReportNo, widget.user.uid!);
            _initializeLikeState(); // 좋아요 상태 업데이트
          },
        ),
        Text('$likesCount'),
      ],
    );
  }

  Widget buildFavoriteButton() {
    // isFavorited가 null이면 아이콘을 표시하지 않음
    if (isFavorited == null) return Container();

    return Row(
      children: [
        IconButton(
          icon: isFavorited!
              ? const Icon(Icons.star)
              : const Icon(Icons.star_border),
          onPressed: () async {
            await likeRepository.toggleFavorite(
                widget.supplement.productReportNo, widget.user.uid!);
            _initializeFavoriteState(); // 찜하기 상태 업데이트
          },
        ),
        Text('$favoritesCount'),
      ],
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
