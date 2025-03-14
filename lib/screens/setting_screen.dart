import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../component/setting_component.dart';
import '../component/setting_line_component.dart';

class SettingScreen extends StatefulWidget {
  final Function()? onTap;
  const SettingScreen({super.key, this.onTap});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;

    return Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(builder: (context, constraints) {
          final isScrollable = constraints.maxHeight < 600;
          final screenWidth = MediaQuery.of(context).size.width; // 화면 너비
          final isTablet = screenWidth >= 768; // 아이패드 여부 판단

          final content = Container(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 33 * pixel),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 54 * pixel,
                        ),
                        Container(
                          height: 40.0 * pixel,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "설정",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25 * pixel,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SettingBox(
                          onTap: () => {
                            context.go('/root/setting/settingNickname'),
                          },
                          settingText: "로그아웃",
                        ),
                        settingLine(pixel),
                        SettingBox(
                          onTap: () => {
                            context.go('/root/setting/settingPush'),
                          },
                          settingText: "푸시알림 설정",
                        ),
                        settingLine(pixel),
                        SettingBox(
                          onTap: () => {
                            context.go('/root/setting/settingAccount'),
                          },
                          settingText: "회원탈퇴",
                        ),
                        settingLine(pixel),
                      ])));

          // 600보다 작으면 스크롤 적용

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
