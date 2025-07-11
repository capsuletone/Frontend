import 'package:capsuleton_flutter/component/auth_logout_component.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../component/highlight_text_component.dart';
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
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;

    return Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(builder: (context, constraints) {
          final isScrollable = constraints.maxHeight < 600;
          final screenWidth = MediaQuery.of(context).size.width;
          final isTablet = screenWidth >= 768;
          final pixel = screenWidth / 375 * 0.97;
          final content = Container(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24 * pixel),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: kIsWeb ? 24 * pixel : 54 * pixel),
                        highlightText(pixel, context, "마이페이지"),
                        SizedBox(
                          height: 20 * pixel,
                        ),
                        SettingBox(
                          onTap: () => {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20 * pixel),
                                  ),
                                  child: const AccountLogout(),
                                );
                              },
                            ),
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
                        // SettingBox(
                        //   onTap: () => {
                        //     showDialog(
                        //       context: context,
                        //       builder: (BuildContext context) {
                        //         return Dialog(
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius:
                        //                 BorderRadius.circular(20 * pixel),
                        //           ),
                        //           child: ServiceLogout(),
                        //         );
                        //       },
                        //     ),
                        //   },
                        //   settingText: "회원탈퇴",
                        // ),
                        //settingLine(pixel),
                      ])));

          // 600보다 작으면 스크롤 적용

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
