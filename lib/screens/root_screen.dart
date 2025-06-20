import 'package:capsuleton_flutter/screens/prescription_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'calander_screen.dart';
import 'home_screen.dart';
import 'recommended_screen.dart';
import 'setting_screen.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  // 카메라 리스트에서 원하는 카메라 가져옴

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  //late TabController _controller;

  int _selectedRootIndex = 2;
  final bool _isOverlayVisible = true; // 초기 상태: Overlay 표시

  @override
  void initState() {
    super.initState();
  }

  // 각 페이지를 관리할 리스트
  static final List<Widget> _pages = <Widget>[
    const CalanderScreen(), //캘린더 스크린
    const PrescriptionAddScreen(),
    const HomeScreen(),
    const RecommendedScreen(), //추천 스크린
    const SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedRootIndex = index;
    });

    // Navigate based on index
  }

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: _pages[_selectedRootIndex],
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: kIsWeb ? 60 * pixel : 83 * pixel,
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent, // 터치 효과 제거
              highlightColor: Colors.transparent, // 선택 효과 제거
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedRootIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed, // 배경색 변경 방지
              selectedItemColor: const Color(0xFF191F28), // 선택된 아이콘 및 텍스트 색상
              unselectedItemColor:
                  const Color(0x7F191F28), // 비활성화된 아이콘 및 텍스트 색상
              elevation: 0,
              backgroundColor: Colors.white, // ✅ 배경색을 확실히 적용
              selectedLabelStyle: TextStyle(
                color: const Color(0xFF191F28),
                fontSize: 10 * pixel,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: TextStyle(
                color: const Color(0x7F191F28),
                fontSize: 10 * pixel,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.calendar_month, // 원하는 아이콘 설정 (예: 설정 아이콘)

                    size: 25 * pixel, // 크기 설정
                    color: const Color(0x7F191F28), // 색상 적용 (#4E5968)
                  ),
                  activeIcon: Icon(
                    Icons.calendar_month, // 원하는 아이콘 설정 (예: 설정 아이콘)
                    size: 25 * pixel, // 크기 설정
                  ),
                  label: '달력',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.camera_alt, // 원하는 아이콘 설정 (예: 설정 아이콘)

                    size: 25 * pixel, // 크기 설정
                    color: const Color(0x7F191F28), // 색상 적용 (#4E5968)
                  ),
                  activeIcon: Icon(
                    Icons.camera_alt, // 원하는 아이콘 설정 (예: 설정 아이콘)
                    size: 25 * pixel, // 크기 설정
                  ),
                  label: '추가',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined, // 원하는 아이콘 설정 (예: 설정 아이콘)
                    size: 25 * pixel,
                    color: const Color(0x7F191F28), // 크기 설정
                    // 색상 적용 (#4E5968)
                  ),
                  activeIcon: Icon(
                    Icons.home_outlined, // 원하는 아이콘 설정 (예: 설정 아이콘)
                    size: 25 * pixel, // 크기 설정
                  ),
                  label: '홈',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.recommend_outlined, // 원하는 아이콘 설정 (예: 설정 아이콘)
                    size: 25 * pixel, // 크기 설정
                    color: const Color(0x7F191F28), // 색상 적용 (#4E5968)
                    // 색상 적용 (#4E5968)
                  ),
                  activeIcon: Icon(
                    Icons.recommend_outlined, // 원하는 아이콘 설정 (예: 설정 아이콘)

                    size: 25 * pixel, // 크기 설정

                    // 색상 적용 (#4E5968)
                  ),
                  label: '추천',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.account_circle_outlined, // 원하는 아이콘 설정 (예: 설정 아이콘)
                    size: 25 * pixel, // 크기 설정
                    color: const Color(0x7F191F28), // 색상 적용 (#4E5968)
                  ),
                  activeIcon: Icon(
                    Icons.account_circle_outlined, // 원하는 아이콘 설정 (예: 설정 아이콘)
                    size: 25 * pixel, // 크기 설정
                  ),
                  label: '마이페이지',
                ),
              ],
            ),
          ),
        ));
  }
}
