import 'package:capsuleton_flutter/screens/capsule_detail_screen.dart';
import 'package:capsuleton_flutter/screens/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/login_screen.dart';
import '../screens/prescription_screen.dart';
import '../screens/prescription_edit_screen.dart';
import '../screens/prescription_result_screen.dart';
import '../screens/register_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';

class AppRouter {
  final GoRouter _router;
  final GlobalKey<NavigatorState> navigatorKey; // NavigatorKey 선언

  AppRouter()
      : navigatorKey = GlobalKey<NavigatorState>(), // NavigatorKey 초기화
        _router = GoRouter(
          navigatorKey: GlobalKey<NavigatorState>(),
          initialLocation: RoutePaths.splash,
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
          path: RoutePaths.register,
          name: RoutePaths.register,
          builder: (state, _) => RegisterScreen(),
        ),
        _createRoute(
            path: RoutePaths.root,
            name: RouteNames.root,
            builder: (_, state) => RootTab(),
            routes: [
              _createRoute(
                  path: RoutePaths.home,
                  name: RouteNames.home,
                  builder: (_, state) => HomeScreen(),
                  routes: [
                    _createRoute(
                      path: RoutePaths.detail,
                      name: RouteNames.detail,
                      builder: (_, state) => CapsuleDetailScreen(),
                    ),
                  ]),
              _createRoute(
                  path: RoutePaths.preescriptionAdd,
                  name: RoutePaths.preescriptionAdd,
                  builder: (state, _) => PrescriptionAddScreen(),
                  routes: [
                    _createRoute(
                        path: RoutePaths.preescriptionResult,
                        name: RoutePaths.preescriptionResult,
                        builder: (state, _) => PrescriptionResultScreen(),
                        routes: [
                          _createRoute(
                            path: RoutePaths.preescriptionEdit,
                            name: RoutePaths.preescriptionEdit,
                            builder: (state, _) => PrescriptionEditScreen(),
                          )
                        ])
                  ]),
            ]),
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
  static const register = '/register';
  static const home = '/home';
  static const root = '/root';
  static const detail = '/detail';
  static const preescriptionAdd = '/preescriptionAdd';
  static const preescriptionResult = '/preescriptionResult';
  static const preescriptionEdit = '/prescriptionEdit';
}

// 라우트 이름 상수를 정의
class RouteNames {
  static const splash = 'SplashScreen';
  static const login = 'LoginScreen';
  static const register = 'RegisterScreen';
  static const home = 'HomeScreen';
  static const root = 'RootScreen';
  static const detail = 'CapsuleDetailScreen';
  static const preescriptionAdd = 'preescriptionAddScreen';
  static const preescriptionResult = 'preescriptionResultScreen';
  static const preescriptionEdit = 'PrescriptionEditScreen';
}
