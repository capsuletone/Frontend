import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isListEmpty = true;
  bool _isLoading = true; // 로딩 상태를 관리

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = false;
    });

    if (!_isLoading) {
      await _initializeUser();
    }
  }

  Future<void> _initializeUser() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        if (mounted) {
          context.go('/root');
        }
      } else {
        String firebaseUid = user.uid;
        try {
          context.go('/root');
        } catch (error) {
          print("Error during user initialization: $error");
          context.go('/root');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;

    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      final isScrollable = constraints.maxHeight < 600;
      final screenWidth = MediaQuery.of(context).size.width; // 화면 너비
      final isTablet = screenWidth >= 768; // 아이패드 여부 판단

      final content = Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Center(
              child: Text("splash 화면"),
            )
          ]));

      return SingleChildScrollView(
          physics: isScrollable ? null : NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: content,
          ));
    }));
  }
}
