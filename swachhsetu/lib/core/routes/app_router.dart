import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/reports/presentation/screens/report_screen.dart';
import '../../features/reports/presentation/screens/report_success_screen.dart';
import '../../features/ai_detection/presentation/screens/scanner_screen.dart';
import '../../features/maps/presentation/screens/explore_screen.dart';
import '../../features/pickup/presentation/screens/pickup_screen.dart';
import '../../features/pickup/presentation/screens/pickup_success_screen.dart';
import '../../features/tracking/presentation/tracking_screen.dart';
import '../../features/notifications/presentation/notification_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/waste_guide/presentation/guide_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/support/presentation/support_screen.dart';
import '../../features/onboarding/presentation/controllers/onboarding_controller.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final onboardingState = ref.watch(onboardingControllerProvider);
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final location = state.matchedLocation;
      if (onboardingState.isLoading ||
          onboardingState.hasError ||
          authState.isLoading) {
        return location == '/splash' ? null : '/splash';
      }
      if (location == '/splash') {
        if (!onboardingState.value!) return '/onboarding';
        return authState.value?.status == AuthStatus.authenticated
            ? '/home'
            : '/auth';
      }
      if (onboardingState.value! && location == '/onboarding') {
        return '/auth';
      }
      final isAuthenticated =
          authState.value?.status == AuthStatus.authenticated;
      final isAuthRoute =
          location == '/auth' ||
          location == '/register' ||
          location == '/forgot-password';
      final isProtectedRoute =
          location.startsWith('/home') ||
          location.startsWith('/explore') ||
          location.startsWith('/requests') ||
          location.startsWith('/notifications') ||
          location.startsWith('/profile') ||
          location.startsWith('/report') ||
          location.startsWith('/scan') ||
          location.startsWith('/pickup') ||
          location.startsWith('/maps') ||
          location.startsWith('/guide') ||
          location.startsWith('/request-detail') ||
          location.startsWith('/report-success') ||
          location.startsWith('/support');
      if (!isAuthenticated && isProtectedRoute) return '/auth';
      if (isAuthenticated && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/auth', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AuthenticatedShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/explore',
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/requests',
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notifications',
                builder: (context, state) => const NotificationScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/report',
        builder: (context, state) => const ReportScreen(),
      ),
      GoRoute(
        path: '/report-success/:id',
        builder: (context, state) =>
            ReportSuccessScreen(reportId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/scan',
        builder: (context, state) => const ScannerScreen(),
      ),
      GoRoute(
        path: '/pickup',
        builder: (context, state) => const PickupScreen(),
      ),
      GoRoute(
        path: '/pickup-success/:id',
        builder: (context, state) =>
            PickupSuccessScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/pickup-tracking/:id',
        builder: (context, state) =>
            TrackingScreen(id: state.pathParameters['id']!, pickup: true),
      ),
      GoRoute(path: '/maps', redirect: (context, state) => '/explore'),
      GoRoute(path: '/guide', builder: (context, state) => const GuideScreen()),
      GoRoute(
        path: '/support',
        builder: (context, state) => const SupportScreen(),
      ),
      GoRoute(
        path: '/report-tracking/:id',
        builder: (context, state) =>
            TrackingScreen(id: state.pathParameters['id']!, pickup: false),
      ),
      GoRoute(
        path: '/request-detail/:id',
        builder: (context, state) =>
            TrackingScreen(id: state.pathParameters['id']!, pickup: false),
      ),
    ],
  );
});
