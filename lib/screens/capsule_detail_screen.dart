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
    return Scaffold(
      appBar: AppBar(title: Text("약 정보")),
      body: FutureBuilder(
        future: Provider.of<TabletProvider>(context, listen: false)
            .loadTablets('아스피린'),
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
                    // 약 이름
                    Text(
                      tablet.itemName ?? '알 수 없는 약',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),

                    // 약 이미지 (예시 이미지)
                    Center(
                      child: Image.asset(
                        'assets/test.jpg', // 예시 이미지
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 16),

                    // 약 성분
                    Text(
                      '약 성분',
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
