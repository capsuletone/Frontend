import 'package:go_router/go_router.dart';
import '../home/screen/home_screen.dart';
import '../scan/screen/scan_camera_screen.dart';
import '../scan/screen/scan_result_screen.dart';

class AppRouter {
  final GoRouter _router;

  AppRouter()
      : _router = GoRouter(
          initialLocation: '/',
          routes: _getRoutes(),
        );

  GoRouter get router => _router;

  static List<GoRoute> _getRoutes() => [
        GoRoute(
          path: '/',
          name: 'HomeScreen',
          builder: (state, _) => HomeScreen(),
        ),
        GoRoute(
          path: '/scan',
          name: ' TextRecognitionScreen',
          builder: (state, _) => CameraScreen(),
        ),
      ];
}
