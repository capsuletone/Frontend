import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecommendedScreen extends StatefulWidget {
  final Function()? onTap;
  const RecommendedScreen({super.key, this.onTap});

  @override
  State<RecommendedScreen> createState() => _RecommendedScreenState();
}

class _RecommendedScreenState extends State<RecommendedScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;

    return GestureDetector(onTap: () {
      FocusScope.of(context).unfocus(); // 포커스 해제 및 키보드 내리기
    }, child: Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      final isScrollable = constraints.maxHeight < 600;
      final screenWidth = MediaQuery.of(context).size.width; // 화면 너비
      final isTablet = screenWidth >= 768; // 아이패드 여부 판단

      final content = Container(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 33 * pixel),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Center(child: Text("추천 화면"))])));

      // 600보다 작으면 스크롤 적용

      return SingleChildScrollView(
          physics: isScrollable ? null : NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: content,
          ));
    })));
  }
}
