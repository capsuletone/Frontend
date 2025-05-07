import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/tablet_provider.dart';

class CapsuleDetailScreen extends StatefulWidget {
  final String? itemName;
  final Function()? onTap;
  const CapsuleDetailScreen({
    super.key,
    required this.itemName,
    this.onTap,
  });

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
            .loadTablets(widget.itemName!), // 데이터 로드
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 데이터 로딩 중일 때 로딩 인디케이터 표시
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 오류 발생 시 메시지 표시
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
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 23.0 * pixel, // 아이콘 크기
                                  color: Colors.black, // 아이콘 색상
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 40 * pixel,
                      ),
                      const Center(child: Text("약 정보를 찾을 수 없습니다.")),
                    ]));
          }

          // 데이터 로드 완료 후 처리
          return SingleChildScrollView(
            child: Consumer<TabletProvider>(
              builder: (context, provider, child) {
                final tablet = provider.tablet;

                if (tablet == null) {
                  // 캐시된 데이터가 없으면 '약 정보를 찾을 수 없습니다.' 메시지 표시
                  return const Center(child: Text("약 정보를 찾을 수 없습니다."));
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
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 23.0 * pixel, // 아이콘 크기
                                  color: Colors.black, // 아이콘 색상
                                ),
                              ),
                            ],
                          )),
                      // 약 정보 표시
                      Text(
                        tablet.itemName ?? '알 수 없는 약',
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      // 효능, 사용법 등 관련 정보 표시
                      const Text(
                        '효능',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tablet.efcyQesitm ?? '정보 없음',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '사용법',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tablet.useMethodQesitm ?? '정보 없음',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      // 기타 정보들도 동일하게 처리
                      const Text(
                        '주의사항 (경고)',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tablet.atpnWarnQesitm ?? '정보 없음',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '상호작용 (주의해야 할 약 또는 음식)',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tablet.intrcQesitm ?? '정보 없음',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
