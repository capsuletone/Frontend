import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CapsuleDetailScreen extends StatefulWidget {
  final Function()? onTap;
  const CapsuleDetailScreen({super.key, this.onTap});

  @override
  State<CapsuleDetailScreen> createState() => _CapsuleDetailScreenState();
}

class _CapsuleDetailScreenState extends State<CapsuleDetailScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40.0 * pixel, // AppBar 높이

                  color: Colors.white, // 배경색
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start, // 양쪽 정렬
                    crossAxisAlignment: CrossAxisAlignment.center, // 수직 가운데 정렬
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.go('/root'); // 뒤로가기 동작
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 23.0 * pixel, // 아이콘 크기
                          color: Colors.black, // 아이콘 색상
                        ),
                      ),
                    ],
                  ),
                ),
                // 음식 이름
                Text(
                  '약 이름',
                  style: TextStyle(
                      fontSize: 28 * pixel, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                // 음식 이미지
                Center(
                  child: Image.asset(
                    'assets/test.jpg', // 예시 이미지 URL
                    height: 200,

                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),

                // 음식 소개 제목
                Text(
                  '약 성분',
                  style: TextStyle(
                      fontSize: 22 * pixel, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8 * pixel),
                Text(
                  '이 음식은 고급 재료로 만들어져 맛과 영양이 풍부한 음식입니다. 고소하고 부드러운 맛이 특징으로, 누구나 좋아할 만한 메뉴입니다.',
                  style: TextStyle(fontSize: 16 * pixel),
                ),
                SizedBox(height: 16 * pixel),

                // 음식 특징 제목
                Text(
                  '설명',
                  style: TextStyle(
                      fontSize: 22 * pixel, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8 * pixel),
                Text(
                  '1. 신선한 재료 사용\n2. 간편하게 조리 가능\n3. 모든 연령대가 좋아하는 맛',
                  style: TextStyle(fontSize: 16 * pixel),
                ),
                SizedBox(height: 16 * pixel),

                // 음식 주의사항 제목
                Text(
                  '주의사항',
                  style: TextStyle(
                      fontSize: 22 * pixel, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8 * pixel),
                Text(
                  '1. 알레르기가 있을 수 있는 재료가 포함될 수 있습니다.\n2. 너무 많이 섭취하지 마세요.',
                  style: TextStyle(fontSize: 16 * pixel),
                ),
              ],
            )));
  }
}
