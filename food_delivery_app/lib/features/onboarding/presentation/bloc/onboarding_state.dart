import 'package:equatable/equatable.dart';
import '../../domain/entities/onboarding_page_entity.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

/// Loading state
class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

/// Loaded state with pages
class OnboardingLoaded extends OnboardingState {
  final List<OnboardingPageEntity> pages;
  final int currentPage;
  final bool isLastPage;

  const OnboardingLoaded({
    required this.pages,
    required this.currentPage,
    required this.isLastPage,
  });

  bool get isFirstPage => currentPage == 0;

  OnboardingLoaded copyWith({
    List<OnboardingPageEntity>? pages,
    int? currentPage,
    bool? isLastPage,
  }) {
    return OnboardingLoaded(
      pages: pages ?? this.pages,
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }

  @override
  List<Object?> get props => [pages, currentPage, isLastPage];
}

/// Onboarding already completed
class OnboardingAlreadyCompleted extends OnboardingState {
  const OnboardingAlreadyCompleted();
}

/// Onboarding completed successfully
class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted();
}

/// Error state
class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError({required this.message});

  @override
  List<Object?> get props => [message];
}
