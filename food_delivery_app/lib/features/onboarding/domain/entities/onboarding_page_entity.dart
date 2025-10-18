import 'package:equatable/equatable.dart';

/// Entity representing an onboarding page
class OnboardingPageEntity extends Equatable {
  final String title;
  final String description;
  final String imagePath;
  final String? backgroundColor;

  const OnboardingPageEntity({
    required this.title,
    required this.description,
    required this.imagePath,
    this.backgroundColor,
  });

  @override
  List<Object?> get props => [title, description, imagePath, backgroundColor];
}
