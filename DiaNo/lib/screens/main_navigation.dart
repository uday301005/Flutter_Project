import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'dashboard_screen.dart';
import 'food_analysis_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const FoodAnalysisScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 100, // Increased height for floating effect
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background
            Container(
              color: Colors.white,
            ),
            // Floating buttons positioned higher
            Positioned(
              top: -20, // This moves buttons up to create floating effect
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFloatingNavButton(
                    icon: Icons.dashboard,
                    color: _currentIndex == 0 ? const Color(0xFF2E7D32) : Colors.grey,
                    onTap: () => setState(() => _currentIndex = 0),
                  ),
                  _buildFloatingNavButton(
                    icon: Icons.receipt,
                    color: _currentIndex == 0 ? const Color(0xFF2E7D32) : Colors.grey,
                    onTap: () => setState(() => _currentIndex = 0),
                  ),
                  _buildFloatingNavButton(
                    icon: Icons.camera_alt,
                    color: _currentIndex == 1 ? const Color(0xFF2E7D32) : Colors.grey,
                    onTap: () => setState(() => _currentIndex = 1),
                  ),
                  _buildFloatingNavButton(
                    icon: Icons.history,
                    color: _currentIndex == 2 ? const Color(0xFF2E7D32) : Colors.grey,
                    onTap: () => setState(() => _currentIndex = 2),
                  ),
                  _buildFloatingNavButton(
                    icon: Icons.settings,
                    color: _currentIndex == 3 ? const Color(0xFF2E7D32) : Colors.grey,
                    onTap: () => setState(() => _currentIndex = 3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingNavButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
      ),
    );
  }
}
