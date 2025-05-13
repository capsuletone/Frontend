import 'package:capsuleton_flutter/screens/capsule_detail_screen.dart';
import 'package:capsuleton_flutter/screens/root_screen.dart';
import 'package:capsuleton_flutter/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/login_screen.dart';
import '../screens/prescription_manually_screen.dart';
import '../screens/prescription_screen.dart';
import '../screens/register_screen.dart';
import '../screens/scan_camera_screen.dart';
import '../screens/setting_push_screen.dart';
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
          builder: (_, state) => const SplashScreen(),
        ),
        _createRoute(
          path: RoutePaths.login,
          name: RouteNames.login,
          builder: (_, state) => const LoginScreen(),
        ),
        _createRoute(
          path: RoutePaths.register,
          name: RoutePaths.register,
          builder: (state, _) => const RegisterScreen(),
        ),
        _createRoute(
            path: RoutePaths.root,
            name: RouteNames.root,
            builder: (_, state) => const RootTab(),
            routes: [
              _createRoute(
                  path: RoutePaths.setting,
                  name: RouteNames.setting,
                  builder: (_, state) => const SettingScreen(),
                  routes: [
                    _createRoute(
                      path: RoutePaths.settingPush,
                      name: RouteNames.settingPush,
                      builder: (_, state) => SettingPushScreen(),
                    )
                  ]),
              _createRoute(
                  path: RoutePaths.home,
                  name: RouteNames.home,
                  builder: (_, state) => const HomeScreen(),
                  routes: [
                    _createRoute(
                      path: RoutePaths.detail,
                      name: RouteNames.detail,
                      builder: (_, state) => const CapsuleDetailScreen(
                        itemName: '',
                      ),
                    ),
                  ]),
              _createRoute(
                  path: RoutePaths.preescriptionAdd,
                  name: RoutePaths.preescriptionAdd,
                  builder: (state, _) => const PrescriptionAddScreen(),
                  routes: [
                    _createRoute(
                      path: RoutePaths.camera,
                      name: RouteNames.camera,
                      builder: (_, state) => const CameraScreen(),
                    ),
                    _createRoute(
                      path: RoutePaths.prescriptionManually,
                      name: RouteNames.prescriptionManually,
                      builder: (_, state) => const PrescriptionManuallyScreen(),
                    ),
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
  static const camera = '/camera';
  static const preescriptionAdd = '/preescriptionAdd';
  static const preescriptionResult = '/preescriptionResult';
  static const preescriptionEdit = '/prescriptionEdit';
  static const prescriptionManually = '/prescriptionManually';
  static const setting = '/setting';
  static const settingPush = '/settingPush';
}

// 라우트 이름 상수를 정의
class RouteNames {
  static const splash = 'SplashScreen';
  static const login = 'LoginScreen';
  static const register = 'RegisterScreen';
  static const home = 'HomeScreen';
  static const root = 'RootScreen';
  static const detail = 'CapsuleDetailScreen';
  static const camera = 'CameraScreen';
  static const preescriptionAdd = 'preescriptionAddScreen';
  static const preescriptionResult = 'preescriptionResultScreen';
  static const preescriptionEdit = 'PrescriptionEditScreen';
  static const prescriptionManually = 'PrescriptionManuallyScreen';
  static const setting = 'settingScreen';
  static const settingPush = 'settingPushScreen';
}
