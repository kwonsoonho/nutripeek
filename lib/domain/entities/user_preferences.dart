class UserPreferences {
  final List<String> favoriteSupplements; // 찜한 영양제 ID 목록
  final List<String> likedSupplements; // 좋아요한 영양제 ID 목록

  UserPreferences({
    required this.favoriteSupplements,
    required this.likedSupplements,
  });

// 기타 도메인 로직, 예: 찜한 영양제 추가/제거, 좋아요한 영양제 추가/제거 등
}
