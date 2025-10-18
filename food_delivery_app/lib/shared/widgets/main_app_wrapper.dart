import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/search/presentation/pages/search_screen.dart';
import '../../features/profile/presentation/pages/profile_menu_screen.dart';
import 'bottom_navigation_bar.dart';

/// Main App Wrapper - Contains bottom navigation and manages tab switching
class MainAppWrapper extends StatefulWidget {
  final int initialIndex;

  const MainAppWrapper({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainAppWrapper> createState() => _MainAppWrapperState();
}

class _MainAppWrapperState extends State<MainAppWrapper> {
  late int _currentIndex;
  late PageController _pageController;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const _PlaceholderScreen(title: 'Orders', message: 'Orders screen coming soon!'),
    const ProfileMenuScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

/// Placeholder screen widget for routes that are not yet implemented
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String message;

  const _PlaceholderScreen({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
