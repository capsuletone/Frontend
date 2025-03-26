import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../component/date_picker_popup_component.dart';
import 'package:intl/intl.dart';

import '../component/highlight_text_component.dart';
import '../component/home_qrcode_scan_component.dart';

class PrescriptionResultScreen extends StatefulWidget {
  final Function()? onTap;
  const PrescriptionResultScreen({super.key, this.onTap});

  @override
  State<PrescriptionResultScreen> createState() =>
      _PrescriptionResultScreenState();
}

class _PrescriptionResultScreenState extends State<PrescriptionResultScreen> {
  String? _formattedDate;
  TextEditingController _controller = TextEditingController();
  List<String> items = [
    '첫 번째 아이템',
    '두 번째 아이템',
    '세 번째 아이템',
    '네 번째 아이템',
    '다섯 번째 아이템'
  ];

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;
    if (_formattedDate == null) {
      _formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // 포커스 해제 및 키보드 내리기
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: LayoutBuilder(builder: (context, constraints) {
              final isScrollable = constraints.maxHeight < 600;
              final screenWidth = MediaQuery.of(context).size.width; // 화면 너비
              final isTablet = screenWidth >= 768; // 아이패드 여부 판단

              final content = Padding(
                  padding: EdgeInsets.all(16.0 * pixel),
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
                        highlightText(pixel, context, "약 추가"),
                        SizedBox(height: 24 * pixel),
                        Row(
                          children: [
                            Text(
                              '복용 목적',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16 * pixel,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 6 * pixel,
                            ),
                            Container(
                                width: 250 * pixel,
                                child: TextField(
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    labelText: 'ex)두통',
                                    border: OutlineInputBorder(),
                                  ),
                                )),
                          ],
                        ),
                        Container(
                            height: 400 * pixel,
                            child: ListView.builder(
                              itemCount: items.length, // 리스트의 개수
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8), // 아이템 사이 간격
                                  padding: EdgeInsets.all(16), // 내부 여백
                                  decoration: BoxDecoration(
                                    color: index.isOdd
                                        ? Colors.blueGrey
                                        : Colors.lightGreen, // 짝/홀수 인덱스에 따른 색상
                                    borderRadius:
                                        BorderRadius.circular(8), // 둥근 모서리
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    items[index], // 아이템 텍스트
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              },
                            )),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          color: Colors.blueAccent,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_controller.text.isNotEmpty) {
                                setState(() {
                                  // 텍스트를 리스트에 추가
                                  items.add(_controller.text);
                                  _controller.clear(); // 입력된 텍스트 필드 비우기
                                });
                              }
                            },
                            child: Text('추가'),
                          ),
                        ),
                        SizedBox(
                          height: 40 * pixel,
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          color: Colors.blueAccent,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('완료'),
                          ),
                        ),
                      ]));

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
