import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/tablet_provider.dart';

class CapsuleDetailScreen extends StatefulWidget {
  final Function()? onTap;
  const CapsuleDetailScreen({super.key, this.onTap});

  @override
  State<CapsuleDetailScreen> createState() => _CapsuleDetailScreenState();
}

class _CapsuleDetailScreenState extends State<CapsuleDetailScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: Provider.of<TabletProvider>(context, listen: false)
            .loadTablets('보령'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(child: Consumer<TabletProvider>(
            builder: (context, provider, child) {
              final tablet = provider.tablet;

              if (tablet == null) {
                return Center(child: Text("약 정보를 찾을 수 없습니다."));
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 54 * pixel),

                    Container(
                      height: 40.0 * pixel, // AppBar 높이

                      color: Colors.white, // 배경색
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start, // 양쪽 정렬
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // 수직 가운데 정렬
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
                    Text(
                      tablet.itemName ?? '알 수 없는 약',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),

                    // 약 이미지 (예시 이미지)
                    // Center(
                    //   child: Image.asset(
                    //     'assets/test.jpg', // 예시 이미지
                    //     height: 200,
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    SizedBox(height: 16),

                    // 약 성분
                    Text(
                      '효능',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      tablet.efcyQesitm ?? '정보 없음',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),

                    // 사용법
                    Text(
                      '사용법',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      tablet.useMethodQesitm ?? '정보 없음',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),

                    // 주의사항(경고)
                    Text(
                      '주의사항 (경고)',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      tablet.atpnWarnQesitm ?? '정보 없음',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),

                    // 주의사항
                    Text(
                      '주의사항',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      tablet.atpnQesitm ?? '정보 없음',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),

                    // 상호작용 (주의해야 할 약 또는 음식)
                    Text(
                      '상호작용 (주의해야 할 약 또는 음식)',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      tablet.intrcQesitm ?? '정보 없음',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            },
          ));
        },
      ),
    );
  }
}
