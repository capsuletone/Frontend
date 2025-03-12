import 'package:capsuleton_flutter/screen/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screen/login_screen.dart';
import '../screen/splash_screen.dart';
import '../screen/home_screen.dart';

class AppRouter {
  final GoRouter _router;
  final GlobalKey<NavigatorState> navigatorKey; // NavigatorKey 선언

  AppRouter()
      : navigatorKey = GlobalKey<NavigatorState>(), // NavigatorKey 초기화
        _router = GoRouter(
          navigatorKey: GlobalKey<NavigatorState>(),
          initialLocation: RoutePaths.root,
          routes: _buildRoutes(),
        );

  GoRouter get router => _router;

  static List<GoRoute> _buildRoutes() => [
        _createRoute(
          path: RoutePaths.splash,
          name: RouteNames.splash,
          builder: (_, state) => SplashScreen(),
        ),
        _createRoute(
          path: RoutePaths.login,
          name: RouteNames.login,
          builder: (_, state) => LoginScreen(),
        ),
        _createRoute(
          path: RoutePaths.root,
          name: RouteNames.root,
          builder: (_, state) => RootTab(),
        ),
        _createRoute(
          path: RoutePaths.home,
          name: RouteNames.home,
          builder: (_, state) => HomeScreen(),
        ),
      ];

  static GoRoute _createRoute({
    required String path,
    required String name,
    required Widget Function(BuildContext, GoRouterState) builder,
    List<GoRoute>? routes,
  }) =>
      GoRoute(
        path: path,
        name: name,
        builder: builder,
        routes: routes ?? [],
      );
}

// 경로 상수를 정의해 유지보수성 향상
class RoutePaths {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const root = '/root';
}

// 라우트 이름 상수를 정의
class RouteNames {
  static const splash = 'SplashScreen';
  static const login = 'LoginScreen';
  static const home = 'HomeScreen';
  static const root = 'RootScreen';
}
