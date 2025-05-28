//splash
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  void _initializeUser() {
    Future.delayed(const Duration(seconds: 2)).then((_) {
      context.go('/login');
    }).catchError((error) {
      print("Error during user initialization: $error");

      context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;

    return Scaffold(
        backgroundColor: Colors.green[300],
        body: LayoutBuilder(builder: (context, constraints) {
          final isScrollable = constraints.maxHeight < 600;
          final screenWidth = MediaQuery.of(context).size.width; // 화면 너비
          final isTablet = screenWidth >= 768; // 아이패드 여부 판단

          final content = Padding(
              padding: EdgeInsets.symmetric(horizontal: 24 * pixel),
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Center(
                        child: Icon(
                      Icons.medication, // 원하는 아이콘 설정
                      size: 200 * pixel, // 크기 조절
                      color: Colors.white, // 색상 지정
                    ))
                  ])));

          return SingleChildScrollView(
              physics:
                  isScrollable ? null : const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: content,
              ));
        }));
  }
}
