import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../component/date_picker_popup_component.dart';
import 'package:intl/intl.dart';

class PrescriptionEditScreen extends StatefulWidget {
  final Function()? onTap;
  const PrescriptionEditScreen({super.key, this.onTap});

  @override
  State<PrescriptionEditScreen> createState() => _PrescriptionEditScreenState();
}

class _PrescriptionEditScreenState extends State<PrescriptionEditScreen> {
  String? _formattedDate;
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
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24 * pixel, vertical: 10 * pixel),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "날짜",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Color(0xFF191F28),
                                      fontSize: 14 * pixel,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -1,
                                    ),
                                  )
                                ])),
                        Container(
                          width: 350 * pixel,
                          height: 56 * pixel,
                          margin: EdgeInsets.symmetric(
                            horizontal: 24 * pixel,
                          ),
                          padding: EdgeInsets.only(
                              left: 21 * pixel, top: 17 * pixel),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1, color: Color(0x7F191F28)),
                              borderRadius: BorderRadius.circular(16 * pixel),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              final selectedDate =
                                  await showModalBottomSheet<DateTime>(
                                context: context,
                                backgroundColor:
                                    Colors.transparent, // 전체 배경을 투명하게 설정
                                isScrollControlled:
                                    true, // 팝업이 화면을 가득 채울 수 있도록 설정
                                builder: (BuildContext context) {
                                  return DatePickerPopupComponent(
                                    onSelected: (DateTime date) {
                                      Navigator.pop(context, date); // 선택된 날짜 반환
                                    },
                                  );
                                },
                              );

                              if (selectedDate != null) {
                                setState(() {
                                  _formattedDate =
                                      DateFormat('yyyy-MM-dd', 'ko_KR')
                                          .format(selectedDate);
                                });
                              }
                            },
                            child: Text(
                              _formattedDate!,
                              style: TextStyle(
                                color: Color(0xFF3182F6),
                                fontSize: 16 * pixel,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                letterSpacing: -1,
                              ),
                            ),
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
