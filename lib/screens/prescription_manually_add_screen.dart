import 'package:capsuleton_flutter/database/saveuser_request_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../component/prescription_passivit_add_date_component.dart';

class AddMedicineItemScreen extends StatefulWidget {
  final Function()? onTap;
  const AddMedicineItemScreen({super.key, this.onTap});

  @override
  State<AddMedicineItemScreen> createState() => _AddMedicineItemScreenState();
}

class _AddMedicineItemScreenState extends State<AddMedicineItemScreen> {
  String? _storedTotalDays;
  String? _formattedDate;
  TextEditingController _diseaseCodecontroller = TextEditingController(); //질병코드
  TextEditingController _medicineNamecontroller = TextEditingController(); //약이름
  TextEditingController _timecontroller = TextEditingController(); //허루 복용 시간
  TextEditingController _totalDayscontroller = TextEditingController(); //복용 주기
  TextEditingController _dateCodecontroller = TextEditingController(); //시작일

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;
    if (_formattedDate == null) {
      _formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    if (_dateCodecontroller.text == '') {
      _dateCodecontroller.text =
          DateFormat('yyyy-MM-dd').format(DateTime.now());
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
                                '질병코드',
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
                                    controller: _diseaseCodecontroller,
                                    decoration: InputDecoration(
                                      labelText: 'ex) R51',
                                      border: OutlineInputBorder(),
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(height: 20 * pixel),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '약 이름',
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
                                    controller: _medicineNamecontroller,
                                    decoration: InputDecoration(
                                      labelText: 'ex) 타이레놀',
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
                                  '복용 횟수',
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
                                Container(
                                    width: 250 * pixel,
                                    child: TextField(
                                      controller: _timecontroller,
                                      decoration: InputDecoration(
                                        labelText: 'ex) 아침,점심,져녁',
                                        border: OutlineInputBorder(),
                                      ),
                                    )),
                              ]),
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
                                Container(
                                  width: 250 * pixel,
                                  child: TextField(
                                    controller: _totalDayscontroller,
                                    keyboardType: TextInputType
                                        .number, // 숫자만 입력할 수 있도록 설정
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly, // 숫자만 허용
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'ex) 3일',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (text) {
                                      // "일"을 덧붙여서 표시하지만, 실제 값은 "일" 없이 저장
                                      if (text.isNotEmpty &&
                                          !text.endsWith('일')) {
                                        _totalDayscontroller.text = '$text일';
                                        _totalDayscontroller.selection =
                                            TextSelection.fromPosition(
                                          TextPosition(
                                              offset: _totalDayscontroller
                                                  .text.length),
                                        );
                                      }
                                      // 저장되는 값은 "일" 없이 관리
                                      _storedTotalDays = text; // 실제 저장할 값
                                    },
                                  ),
                                ),
                              ]),
                          SizedBox(height: 20 * pixel),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '복용 시작 일',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16 * pixel,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 20 * pixel,
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
                                        _dateCodecontroller.text =
                                            _formattedDate.toString();
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
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       '유의사항',
                          //       style: TextStyle(
                          //         color: Colors.black,
                          //         fontSize: 16 * pixel,
                          //         fontFamily: 'Pretendard',
                          //         fontWeight: FontWeight.w600,
                          //       ),
                          //     ),
                          //     SizedBox(height: 20 * pixel),
                          //     Container(
                          //         width: 250 * pixel,
                          //         child: TextField(
                          //           controller: _controller,
                          //           decoration: InputDecoration(
                          //             labelText: 'ex) 이 약은 졸음을 유발해요.',
                          //             border: OutlineInputBorder(),
                          //           ),
                          //         )),
                          //   ],
                          // ),
                        ])),
                        Container(
                            child: Column(children: [
                          GestureDetector(
                              onTap: () {
                                String diseaseCode =
                                    _diseaseCodecontroller.text;
                                String medicineName =
                                    _medicineNamecontroller.text;
                                String time = _timecontroller.text;
                                String totalDays = _storedTotalDays!;
                                String startDate = _dateCodecontroller.text;

                                // 결과 출력 (디버깅 용)
                                debugPrint('질병코드: $diseaseCode');
                                debugPrint('약 이름: $medicineName');
                                debugPrint('복용 횟수: $time');
                                debugPrint('복용 주기: $totalDays');
                                debugPrint('복용 시작 일: $startDate');

                                final newItem = SaveUserDatabase(
                                  userid: 'greed', // 실제 사용자 ID 있으면 대체
                                  diseaseCode: diseaseCode,
                                  medicineName: medicineName,
                                  time: time,
                                  totalDays: int.tryParse(totalDays ?? '0'),
                                  date: startDate,
                                );

                                Navigator.pop(context, newItem); // ✅ 데이터 전달
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
