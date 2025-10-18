import 'package:bloc/bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/check_onboarding_status_usecase.dart';
import '../../domain/usecases/complete_onboarding_usecase.dart';
import '../../domain/usecases/get_onboarding_pages_usecase.dart';
import '../../domain/usecases/save_onboarding_preferences_usecase.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CheckOnboardingStatusUseCase checkOnboardingStatusUseCase;
  final GetOnboardingPagesUseCase getOnboardingPagesUseCase;
  final CompleteOnboardingUseCase completeOnboardingUseCase;
  final SaveOnboardingPreferencesUseCase saveOnboardingPreferencesUseCase;

  OnboardingBloc({
    required this.checkOnboardingStatusUseCase,
    required this.getOnboardingPagesUseCase,
    required this.completeOnboardingUseCase,
    required this.saveOnboardingPreferencesUseCase,
  }) : super(const OnboardingInitial()) {
    on<CheckOnboardingStatusEvent>(_onCheckOnboardingStatus);
    on<LoadOnboardingPagesEvent>(_onLoadOnboardingPages);
    on<NextPageEvent>(_onNextPage);
    on<PreviousPageEvent>(_onPreviousPage);
    on<UpdatePageIndexEvent>(_onUpdatePageIndex);
    on<SkipOnboardingEvent>(_onSkipOnboarding);
    on<CompleteOnboardingEvent>(_onCompleteOnboarding);
  }

  Future<void> _onCheckOnboardingStatus(
    CheckOnboardingStatusEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const OnboardingLoading());

    final result = await checkOnboardingStatusUseCase(NoParams());

    result.fold(
      (failure) => emit(OnboardingError(message: failure.message)),
      (isComplete) {
        if (isComplete) {
          emit(const OnboardingAlreadyCompleted());
        } else {
          add(const LoadOnboardingPagesEvent());
        }
      },
    );
  }

  Future<void> _onLoadOnboardingPages(
    LoadOnboardingPagesEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const OnboardingLoading());

    final result = await getOnboardingPagesUseCase(NoParams());

    result.fold(
      (failure) => emit(OnboardingError(message: failure.message)),
      (pages) {
        if (pages.isEmpty) {
          emit(const OnboardingError(message: 'No onboarding pages available'));
        } else {
          emit(OnboardingLoaded(
            pages: pages,
            currentPage: 0,
            isLastPage: pages.length == 1,
          ));
        }
      },
    );
  }

  void _onNextPage(
    NextPageEvent event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingLoaded) {
      final currentState = state as OnboardingLoaded;
      final nextPage = currentState.currentPage + 1;

      if (nextPage < currentState.pages.length) {
        emit(currentState.copyWith(
          currentPage: nextPage,
          isLastPage: nextPage == currentState.pages.length - 1,
        ));
      } else {
        // Last page reached, complete onboarding
        add(const CompleteOnboardingEvent());
      }
    }
  }

  void _onPreviousPage(
    PreviousPageEvent event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingLoaded) {
      final currentState = state as OnboardingLoaded;
      final previousPage = currentState.currentPage - 1;

      if (previousPage >= 0) {
        emit(currentState.copyWith(
          currentPage: previousPage,
          isLastPage: false,
        ));
      }
    }
  }

  void _onUpdatePageIndex(
    UpdatePageIndexEvent event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingLoaded) {
      final currentState = state as OnboardingLoaded;

      if (event.pageIndex >= 0 && event.pageIndex < currentState.pages.length) {
        emit(currentState.copyWith(
          currentPage: event.pageIndex,
          isLastPage: event.pageIndex == currentState.pages.length - 1,
        ));
      }
    }
  }

  Future<void> _onSkipOnboarding(
    SkipOnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    // Skip directly to completion
    add(const CompleteOnboardingEvent());
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const OnboardingLoading());

    // Save preferences if provided
    if (event.preferences != null && event.preferences!.isNotEmpty) {
      final prefsResult = await saveOnboardingPreferencesUseCase(
        SavePreferencesParams(preferences: event.preferences!),
      );

      prefsResult.fold(
        (failure) {
          emit(OnboardingError(message: 'Failed to save preferences: ${failure.message}'));
          return;
        },
        (_) {}, // Continue
      );
    }

    // Mark onboarding as complete
    final result = await completeOnboardingUseCase(NoParams());

    result.fold(
      (failure) => emit(OnboardingError(message: failure.message)),
      (_) => emit(const OnboardingCompleted()),
    );
  }
}
