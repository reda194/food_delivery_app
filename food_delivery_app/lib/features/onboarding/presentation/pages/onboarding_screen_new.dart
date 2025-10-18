import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/routes/route_names.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/onboarding_page_widget.dart';
import '../widgets/page_indicator.dart';

/// Enhanced Onboarding Screen with multi-page support, skip, and persistence
class OnboardingScreenNew extends StatefulWidget {
  const OnboardingScreenNew({super.key});

  @override
  State<OnboardingScreenNew> createState() => _OnboardingScreenNewState();
}

class _OnboardingScreenNewState extends State<OnboardingScreenNew> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Check onboarding status on init
    context.read<OnboardingBloc>().add(const CheckOnboardingStatusEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    context.read<OnboardingBloc>().add(UpdatePageIndexEvent(index));
  }

  void _navigateToAuth(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(RouteNames.login);
  }

  void _handleSkip() {
    context.read<OnboardingBloc>().add(const SkipOnboardingEvent());
  }

  void _handleNext(OnboardingLoaded state) {
    if (state.isLastPage) {
      context.read<OnboardingBloc>().add(const CompleteOnboardingEvent());
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handlePrevious() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingAlreadyCompleted) {
            _navigateToAuth(context);
          } else if (state is OnboardingCompleted) {
            _navigateToAuth(context);
          } else if (state is OnboardingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is OnboardingLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is OnboardingLoaded) {
            return SafeArea(
              child: Column(
                children: [
                  // Skip button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.space16),
                      child: TextButton(
                        onPressed: _handleSkip,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // PageView with onboarding pages
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: state.pages.length,
                      itemBuilder: (context, index) {
                        return OnboardingPageWidget(
                          page: state.pages[index],
                        );
                      },
                    ),
                  ),

                  // Page indicators
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.space24,
                    ),
                    child: PageIndicator(
                      currentPage: state.currentPage,
                      pageCount: state.pages.length,
                    ),
                  ),

                  // Navigation buttons
                  Padding(
                    padding: const EdgeInsets.all(AppDimensions.space24),
                    child: Row(
                      children: [
                        // Back button (visible only if not first page)
                        if (!state.isFirstPage)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _handlePrevious,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusMD,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Back',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),

                        if (!state.isFirstPage)
                          const SizedBox(width: AppDimensions.space16),

                        // Next/Get Started button
                        Expanded(
                          flex: state.isFirstPage ? 1 : 1,
                          child: ElevatedButton(
                            onPressed: () => _handleNext(state),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMD,
                                ),
                              ),
                            ),
                            child: Text(
                              state.isLastPage ? 'Get Started' : 'Next',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          // Initial or error state
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
