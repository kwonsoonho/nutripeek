import 'package:cloud_firestore/cloud_firestore.dart';

class Supplement {
  final String businessName;
  final String capsuleIngredients;
  final String cautionWhenTaking;
  final String childFriendlyCertification;
  final String expirationDays;
  final String functionalIngredients;
  final String highCalorieLowNutrition;
  final String industryType;
  final String intakeMethod;
  final String lastUpdateDate;
  final String lcnsNo;
  final String otherIngredients;
  final String packagingMaterial;
  final String permissionDate;
  final String primaryFunctionality;
  final String productForm;
  final String productName;
  final String productReportNo;
  final String productType;
  final String productionEnd;
  final String shape;
  final String standardSpecification;
  final String storageMethod;
  final String type;
  final Map<String, bool> likes; // Key: userID, Value: isLiked
  final Map<String, bool> favorites; // Key: userID, Value: isFavorited

  Supplement({
    required this.businessName,
    required this.capsuleIngredients,
    required this.cautionWhenTaking,
    required this.childFriendlyCertification,
    required this.expirationDays,
    required this.functionalIngredients,
    required this.highCalorieLowNutrition,
    required this.industryType,
    required this.intakeMethod,
    required this.lastUpdateDate,
    required this.lcnsNo,
    required this.otherIngredients,
    required this.packagingMaterial,
    required this.permissionDate,
    required this.primaryFunctionality,
    required this.productForm,
    required this.productName,
    required this.productReportNo,
    required this.productType,
    required this.productionEnd,
    required this.shape,
    required this.standardSpecification,
    required this.storageMethod,
    required this.type,
    required this.likes,
    required this.favorites,
  });

  factory Supplement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Supplement(
      businessName: data['businessName'],
      capsuleIngredients: data['capsuleIngredients'],
      cautionWhenTaking: data['cautionWhenTaking'],
      childFriendlyCertification: data['childFriendlyCertification'],
      expirationDays: data['expirationDays'],
      functionalIngredients: data['functionalIngredients'],
      highCalorieLowNutrition: data['highCalorieLowNutrition'],
      industryType: data['industryType'],
      intakeMethod: data['intakeMethod'],
      lastUpdateDate: data['lastUpdateDate'],
      lcnsNo: data['lcnsNo'],
      otherIngredients: data['otherIngredients'],
      packagingMaterial: data['packagingMaterial'],
      permissionDate: data['permissionDate'],
      primaryFunctionality: data['primaryFunctionality'],
      productForm: data['productForm'],
      productName: data['productName'],
      productReportNo: data['productReportNo'],
      productType: data['productType'],
      productionEnd: data['productionEnd'],
      shape: data['shape'],
      standardSpecification: data['standardSpecification'],
      storageMethod: data['storageMethod'],
      type: data['type'],
      likes: Map<String, bool>.from(data['likes'] ?? {}),
      favorites: Map<String, bool>.from(data['favorites'] ?? {}),
    );
  }
}
