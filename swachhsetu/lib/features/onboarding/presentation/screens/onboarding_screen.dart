import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_page_indicator.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
      title: 'Sort Waste Smarter',
      description:
          'Identify different types of waste and learn how to dispose of them responsibly.',
      icon: Icons.recycling_rounded,
      color: AppColors.primary,
    ),
    _OnboardingPage(
      title: 'Report. Request. Resolve.',
      description:
          'Report garbage and sanitation problems, or request waste pickup from your location.',
      icon: Icons.campaign_rounded,
      color: AppColors.secondary,
    ),
    _OnboardingPage(
      title: 'Build a Cleaner Community',
      description:
          'Track your requests, discover nearby waste facilities, and contribute to a cleaner environment.',
      icon: Icons.park_rounded,
      color: AppColors.accent,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(onboardingControllerProvider.notifier).completeOnboarding();
    if (mounted) context.go('/auth');
  }

  void _next() {
    if (_currentPage == _pages.length - 1) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _finish,
                      child: const Text('Skip'),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pages.length,
                      onPageChanged: (page) =>
                          setState(() => _currentPage = page),
                      itemBuilder: (context, index) {
                        return _OnboardingContent(
                          page: _pages[index],
                          maxHeight: constraints.maxHeight,
                        );
                      },
                    ),
                  ),
                  OnboardingPageIndicator(currentPage: _currentPage),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: _next,
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? 'Get Started'
                          : 'Next',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent({required this.page, required this.maxHeight});

  final _OnboardingPage page;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final illustrationSize = (maxHeight * 0.28).clamp(150.0, 230.0);
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: maxHeight * 0.68),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: maxHeight < 600 ? AppSpacing.sm : AppSpacing.lg),
            Container(
              width: illustrationSize,
              height: illustrationSize,
              decoration: BoxDecoration(
                color: page.color.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: illustrationSize * 0.62,
                  height: illustrationSize * 0.62,
                  decoration: BoxDecoration(
                    color: page.color,
                    borderRadius: BorderRadius.circular(AppRadii.large),
                  ),
                  child: Icon(
                    page.icon,
                    color: Colors.white,
                    size: illustrationSize * 0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              page.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              page.description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.primaryDark.withAlpha(190),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
}
