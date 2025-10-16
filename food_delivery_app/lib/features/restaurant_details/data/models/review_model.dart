import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/review_entity.dart';

part 'review_model.g.dart';

/// Review Model - Data transfer object with JSON serialization
@JsonSerializable()
class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.userAvatar,
    required super.rating,
    required super.comment,
    required super.createdAt,
    super.images,
    super.helpfulCount,
    super.isVerifiedPurchase,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);

  factory ReviewModel.fromEntity(ReviewEntity entity) {
    return ReviewModel(
      id: entity.id,
      userId: entity.userId,
      userName: entity.userName,
      userAvatar: entity.userAvatar,
      rating: entity.rating,
      comment: entity.comment,
      createdAt: entity.createdAt,
      images: entity.images,
      helpfulCount: entity.helpfulCount,
      isVerifiedPurchase: entity.isVerifiedPurchase,
    );
  }
}
