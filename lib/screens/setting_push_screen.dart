import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../component/setting_line_component.dart';

class SettingPushScreen extends StatefulWidget {
  @override
  _SettingPushScreenState createState() => _SettingPushScreenState();
}

class _SettingPushScreenState extends State<SettingPushScreen> {
  bool _isToggled = false;

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 393 * 0.97;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height, // 화면 높이만큼 제한
                ),
                child: LayoutBuilder(builder: (context, constraints) {
                  final isScrollable = constraints.maxHeight < 600;
                  final screenWidth =
                      MediaQuery.of(context).size.width; // 화면 너비
                  final isTablet = screenWidth >= 768; // 아이패드 여부 판단
                  return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24 * pixel), // 좌우 여백 추가
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isScrollable != true || isTablet != true)
                              SizedBox(
                                height: 54 * pixel,
                              ),
                            Column(children: [
                              GestureDetector(
                                onTap: () {
                                  context.go('/root');
                                },
                                child: const Text("뒤로가기"),
                              ),
                              Container(
                                  height: 120 * pixel,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16 * pixel,
                                      vertical: 18 * pixel),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '케어 알림',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 30 * pixel,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(height: 10 * pixel),
                                              Text(
                                                "약 먹을 시간에 알림",
                                                style: TextStyle(
                                                  color:
                                                      const Color(0x7F191F28),
                                                  fontSize: 13 * pixel,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isToggled = !_isToggled;
                                              });
                                            },
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              width: 50 * pixel,
                                              height: 30 * pixel,
                                              decoration: BoxDecoration(
                                                color: _isToggled
                                                    ? Colors.green[300]
                                                    : Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        25 * pixel),
                                              ),
                                              child: Stack(
                                                children: [
                                                  AnimatedAlign(
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    alignment: _isToggled
                                                        ? Alignment.centerRight
                                                        : Alignment.centerLeft,
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          2.0 * pixel),
                                                      child: Container(
                                                        width: 27 * pixel,
                                                        height: 27 * pixel,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ))
                            ])
                          ]));
                }))));
  }
}
