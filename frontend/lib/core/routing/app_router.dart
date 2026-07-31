import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/zones/presentation/screens/zones_list_screen.dart';
import '../../features/zones/presentation/screens/zone_detail_screen.dart';
import '../../features/alerts/presentation/screens/alerts_screen.dart';
import '../../features/alerts/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/farmers_management_screen.dart';
import '../../features/profile/presentation/screens/devices_management_screen.dart';
import '../../features/zones/presentation/screens/threshold_config_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      final status = authState.status;
      final currentLoc = state.uri.path;

      // While checking status, stay on splash
      if (status == AuthStatus.initial) {
        return '/splash';
      }

      final isLoggedIn = status == AuthStatus.authenticated;
      final isAuthRoute = currentLoc == '/login';
      final isSplashRoute = currentLoc == '/splash';

      if (!isLoggedIn) {
        // If not logged in, force to login unless already there
        if (!isAuthRoute) {
          return '/login';
        }
        return null;
      }

      // If logged in, prevent accessing login/splash
      if (isAuthRoute || isSplashRoute) {
        return '/';
      }

      // Role guards
      final isOwnerRoute = currentLoc.startsWith('/owner');
      final isOwner = authState.role == 'OWNER';

      if (isOwnerRoute && !isOwner) {
        // Non-owner trying to access owner configuration routes -> redirect to dashboard
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      // Shell Route for Bottom Navigation Bar
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainNavigationShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/zones',
            builder: (context, state) => const ZonesListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final idStr = state.pathParameters['id'] ?? '0';
                  final id = int.tryParse(idStr) ?? 0;
                  return ZoneDetailScreen(zoneId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/alerts',
            builder: (context, state) => const AlertsScreen(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      // Owner only routes (outside navigation shell)
      GoRoute(
        path: '/owner/farmers',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FarmersManagementScreen(),
      ),
      GoRoute(
        path: '/owner/devices',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DevicesManagementScreen(),
      ),
      GoRoute(
        path: '/thresholds/:zoneId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final idStr = state.pathParameters['zoneId'] ?? '0';
          final zoneId = int.tryParse(idStr) ?? 0;
          return ThresholdConfigScreen(zoneId: zoneId);
        },
      ),
    ],
  );
});

// A layout widget that wraps the sub-routes in a bottom navigation bar
class MainNavigationShell extends ConsumerWidget {
  final Widget child;

  const MainNavigationShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = GoRouter.of(context);
    final String currentLoc = router.routeInformationProvider.value.uri.path;

    int calculateSelectedIndex() {
      if (currentLoc == '/') return 0;
      if (currentLoc.startsWith('/zones')) return 1;
      if (currentLoc == '/alerts') return 2;
      if (currentLoc == '/notifications') return 3;
      if (currentLoc == '/profile') return 4;
      return 0;
    }

    void onItemTapped(int index) {
      switch (index) {
        case 0:
          context.go('/');
          break;
        case 1:
          context.go('/zones');
          break;
        case 2:
          context.go('/alerts');
          break;
        case 3:
          context.go('/notifications');
          break;
        case 4:
          context.go('/profile');
          break;
      }
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: calculateSelectedIndex(),
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Zones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber_outlined),
            activeIcon: Icon(Icons.warning),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Notices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
