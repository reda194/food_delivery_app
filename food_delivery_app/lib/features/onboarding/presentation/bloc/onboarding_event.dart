import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load onboarding pages
class LoadOnboardingPagesEvent extends OnboardingEvent {
  const LoadOnboardingPagesEvent();
}

/// Event to check onboarding status
class CheckOnboardingStatusEvent extends OnboardingEvent {
  const CheckOnboardingStatusEvent();
}

/// Event to navigate to next page
class NextPageEvent extends OnboardingEvent {
  const NextPageEvent();
}

/// Event to navigate to previous page
class PreviousPageEvent extends OnboardingEvent {
  const PreviousPageEvent();
}

/// Event to skip onboarding
class SkipOnboardingEvent extends OnboardingEvent {
  const SkipOnboardingEvent();
}

/// Event to complete onboarding
class CompleteOnboardingEvent extends OnboardingEvent {
  final Map<String, dynamic>? preferences;

  const CompleteOnboardingEvent({this.preferences});

  @override
  List<Object?> get props => [preferences];
}

/// Event to reset onboarding (for testing)
class ResetOnboardingEvent extends OnboardingEvent {
  const ResetOnboardingEvent();
}

/// Event to update page index
class UpdatePageIndexEvent extends OnboardingEvent {
  final int pageIndex;

  const UpdatePageIndexEvent(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}
