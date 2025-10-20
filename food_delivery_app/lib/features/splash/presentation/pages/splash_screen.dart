import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../../../../core/routes/route_names.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/logger_service.dart';

/// Splash Screen - First screen shown when app launches
/// Handles initialization and routing logic
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final SupabaseService _supabaseService = SupabaseService.instance;
  final LoggerService _logger = LoggerService.instance;

  // Keys for SharedPreferences
  static const String _onboardingCompleteKey = 'ONBOARDING_COMPLETE';
  static const String _appVersionKey = 'APP_VERSION';
  static const String _currentAppVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _initializeApp();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
  }

  /// Main initialization method
  Future<void> _initializeApp() async {
    try {
      _logger.info('Starting app initialization...');

      // Ensure minimum splash screen display time (for better UX)
      final minimumDisplayTime = Future.delayed(const Duration(seconds: 2));

      // Run initialization tasks in parallel where possible
      final results = await Future.wait([
        minimumDisplayTime,
        _checkAuthenticationStatus(),
        _checkOnboardingStatus(),
        _checkAppVersion(),
        _preloadData(),
      ]);

      // Extract results
      final isAuthenticated = results[1] as bool;
      final onboardingComplete = results[2] as bool;
      final isNewVersion = results[3] as bool;

      if (!mounted) return;

      _logger.info('Initialization complete. Auth: $isAuthenticated, '
          'Onboarding: $onboardingComplete, NewVersion: $isNewVersion');

      // Navigate based on app state
      _navigateToAppropriateScreen(
        isAuthenticated: isAuthenticated,
        onboardingComplete: onboardingComplete,
        isNewVersion: isNewVersion,
      );
    } catch (e) {
      _logger.error('Initialization failed: $e');

      if (!mounted) return;

      // On error, default to onboarding or login
      _navigateToAppropriateScreen(
        isAuthenticated: false,
        onboardingComplete: false,
        isNewVersion: false,
      );
    }
  }

  /// Check if user is authenticated
  Future<bool> _checkAuthenticationStatus() async {
    try {
      _logger.info('Checking authentication status...');

      // Check if user has active session
      final user = _supabaseService.currentUser;
      final session = _supabaseService.currentSession;

      final isAuthenticated = user != null && session != null;

      _logger.info('Authentication status: $isAuthenticated');

      return isAuthenticated;
    } catch (e) {
      _logger.error('Failed to check authentication: $e');
      return false;
    }
  }

  /// Check if onboarding has been completed
  Future<bool> _checkOnboardingStatus() async {
    try {
      _logger.info('Checking onboarding status...');

      final prefs = await SharedPreferences.getInstance();
      final onboardingComplete =
          prefs.getBool(_onboardingCompleteKey) ?? false;

      _logger.info('Onboarding complete: $onboardingComplete');

      return onboardingComplete;
    } catch (e) {
      _logger.error('Failed to check onboarding status: $e');
      return false;
    }
  }

  /// Check app version and clear cache if updated
  Future<bool> _checkAppVersion() async {
    try {
      _logger.info('Checking app version...');

      final prefs = await SharedPreferences.getInstance();
      final savedVersion = prefs.getString(_appVersionKey);

      if (savedVersion == null || savedVersion != _currentAppVersion) {
        _logger.info(
            'New version detected: $savedVersion -> $_currentAppVersion');

        // Save new version
        await prefs.setString(_appVersionKey, _currentAppVersion);

        // Clear outdated cache if needed
        // await _clearOutdatedCache();

        return true; // Is new version
      }

      _logger.info('App version up to date: $_currentAppVersion');
      return false; // Not a new version
    } catch (e) {
      _logger.error('Failed to check app version: $e');
      return false;
    }
  }

  /// Preload essential data
  Future<void> _preloadData() async {
    try {
      _logger.info('Preloading data...');

      // Preload any essential data here
      // Examples:
      // - Load app settings
      // - Initialize analytics
      // - Warm up network connections
      // - Load cached data

      // For now, just a placeholder
      await Future.delayed(const Duration(milliseconds: 500));

      _logger.info('Data preloading complete');
    } catch (e) {
      _logger.error('Failed to preload data: $e');
      // Non-critical, continue anyway
    }
  }

  /// Navigate to appropriate screen based on app state
  void _navigateToAppropriateScreen({
    required bool isAuthenticated,
    required bool onboardingComplete,
    required bool isNewVersion,
  }) {
    // Navigation priority:
    // 1. If onboarding not complete -> Onboarding
    // 2. If authenticated -> Home
    // 3. Otherwise -> Login

    String route;

    if (!onboardingComplete) {
      _logger.info('Navigating to onboarding (first time user)');
      route = RouteNames.onboarding;
    } else if (isAuthenticated) {
      _logger.info('Navigating to home (authenticated user)');
      route = RouteNames.home;
    } else {
      _logger.info('Navigating to login (unauthenticated user)');
      route = RouteNames.login;
    }

    // Use pushReplacementNamed to remove splash from navigation stack
    Navigator.of(context).pushReplacementNamed(route);
  }

  /// Optional: Clear outdated cache on version update
  Future<void> _clearOutdatedCache() async {
    try {
      _logger.info('Clearing outdated cache...');

      final prefs = await SharedPreferences.getInstance();

      // Clear specific keys that might be outdated
      // Be careful not to clear user settings or important data
      final keysToKeep = [
        _onboardingCompleteKey,
        _appVersionKey,
        'app_settings', // Settings should persist
      ];

      final allKeys = prefs.getKeys();
      for (final key in allKeys) {
        if (!keysToKeep.contains(key)) {
          await prefs.remove(key);
        }
      }

      _logger.info('Cache cleared successfully');
    } catch (e) {
      _logger.error('Failed to clear cache: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C), // Dark background from Figma
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Name - "Grab Grub"
                const Text(
                  'Grab Grub',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 2,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Tagline - "Eat and Sleep"
                Text(
                  'Eat and Sleep',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 60),

                // Loading indicator
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
