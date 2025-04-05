import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../component/date_picker_popup_component.dart';
import 'package:intl/intl.dart';

import '../component/highlight_text_component.dart';
import '../component/home_qrcode_scan_component.dart';
import '../component/prescription_passive_add_routine.dart';
import '../component/prescription_passivit_add_date_component.dart';

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
  String? _selectCircle = "1일 3회";
  String? _selectcaution = "식후 30분";
  String? _selectPeroid = "3일";

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: Column(children: [
                          Container(
                            height: 40.0 * pixel, // AppBar 높이

                            color: Colors.white, // 배경색
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.start, // 양쪽 정렬
                              crossAxisAlignment:
                                  CrossAxisAlignment.center, // 수직 가운데 정렬
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
                                Text(
                                  '약 추가 ',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25 * pixel,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24 * pixel),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          SizedBox(height: 20 * pixel),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '복용 주기',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16 * pixel,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 30 * pixel,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final selectedDate =
                                        await showModalBottomSheet<DateTime>(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                          ),
                                          child: DateEditPopupContainer(
                                            onSelected: (DateTime date) {
                                              Navigator.pop(context, date);
                                            },
                                          ),
                                        );
                                      },
                                    );

                                    if (selectedDate != null) {
                                      print('Selected date: $selectedDate');
                                      setState(() {
                                        _formattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(selectedDate);
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 250 * pixel,
                                    height: 50 * pixel,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8 * pixel),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black, // 테두리 색상
                                          width: 1.0, // 테두리 두께
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8)), // 둥근 모서리
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formattedDate ??
                                              '날짜 선택', // ✅ null-safe 처리
                                          style: TextStyle(
                                            color: Color(0xFF191F35),
                                            fontSize: 18 * pixel,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          size: 20 * pixel,
                                          color: Color(0xff6B7684),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                          SizedBox(height: 20 * pixel),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '주의사항',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16 * pixel,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 20 * pixel,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final selectedDate =
                                        await showModalBottomSheet<DateTime>(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                          ),
                                          child: DateEditPopupContainer(
                                            onSelected: (DateTime date) {
                                              Navigator.pop(context, date);
                                            },
                                          ),
                                        );
                                      },
                                    );

                                    if (selectedDate != null) {
                                      print('Selected date: $selectedDate');
                                      setState(() {
                                        _formattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(selectedDate);
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 250 * pixel,
                                    height: 50 * pixel,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8 * pixel),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black, // 테두리 색상
                                          width: 1.0, // 테두리 두께
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8)), // 둥근 모서리
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formattedDate ??
                                              '날짜 선택', // ✅ null-safe 처리
                                          style: TextStyle(
                                            color: Color(0xFF191F35),
                                            fontSize: 18 * pixel,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          size: 20 * pixel,
                                          color: Color(0xff6B7684),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                          SizedBox(height: 20 * pixel),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '복용 일',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16 * pixel,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 30 * pixel,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final selectedDate =
                                        await showModalBottomSheet<DateTime>(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                          ),
                                          child: DateEditPopupContainer(
                                            onSelected: (DateTime date) {
                                              Navigator.pop(context, date);
                                            },
                                          ),
                                        );
                                      },
                                    );

                                    if (selectedDate != null) {
                                      print('Selected date: $selectedDate');
                                      setState(() {
                                        _formattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(selectedDate);
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 250 * pixel,
                                    height: 50 * pixel,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8 * pixel),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black, // 테두리 색상
                                          width: 1.0, // 테두리 두께
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8)), // 둥근 모서리
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formattedDate ??
                                              '날짜 선택', // ✅ null-safe 처리
                                          style: TextStyle(
                                            color: Color(0xFF191F35),
                                            fontSize: 18 * pixel,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          size: 20 * pixel,
                                          color: Color(0xff6B7684),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                          SizedBox(height: 20 * pixel),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '유의사항',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16 * pixel,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 20 * pixel),
                              Container(
                                  width: 250 * pixel,
                                  child: TextField(
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      labelText: 'ex) 이 약은 졸음을 유발해요.',
                                      border: OutlineInputBorder(),
                                    ),
                                  )),
                            ],
                          ),
                        ])),
                        Container(
                            child: Column(children: [
                          GestureDetector(
                              onTap: () {
                                context.go('/');
                              },
                              child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16),
                                  color: Colors.green[200],
                                  child: Icon(
                                    Icons.add,
                                    size: 30 * pixel,
                                    color: Colors.white,
                                  ))),
                          SizedBox(
                            height: 10 * pixel,
                          ),
                          GestureDetector(
                              onTap: () {
                                context.go('/');
                              },
                              child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16),
                                  color: Colors.green[400],
                                  child: Text('완료',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17 * pixel,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w500,
                                      )))),
                        ]))
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
