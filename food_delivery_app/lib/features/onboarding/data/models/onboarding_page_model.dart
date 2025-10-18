import '../../domain/entities/onboarding_page_entity.dart';

/// Model for onboarding page data
class OnboardingPageModel extends OnboardingPageEntity {
  const OnboardingPageModel({
    required super.title,
    required super.description,
    required super.imagePath,
    super.backgroundColor,
  });

  /// Create from JSON
  factory OnboardingPageModel.fromJson(Map<String, dynamic> json) {
    return OnboardingPageModel(
      title: json['title'] as String,
      description: json['description'] as String,
      imagePath: json['image_path'] as String,
      backgroundColor: json['background_color'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image_path': imagePath,
      'background_color': backgroundColor,
    };
  }

  /// Create from entity
  factory OnboardingPageModel.fromEntity(OnboardingPageEntity entity) {
    return OnboardingPageModel(
      title: entity.title,
      description: entity.description,
      imagePath: entity.imagePath,
      backgroundColor: entity.backgroundColor,
    );
  }

  /// Convert to entity
  OnboardingPageEntity toEntity() {
    return OnboardingPageEntity(
      title: title,
      description: description,
      imagePath: imagePath,
      backgroundColor: backgroundColor,
    );
  }
}
