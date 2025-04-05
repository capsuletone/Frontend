import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateEditPopupContainer extends StatelessWidget {
  final Function(DateTime) onSelected;

  DateEditPopupContainer({required this.onSelected});

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 393 * 0.97;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 377 * pixel,
          height: 284 * pixel,
          decoration: ShapeDecoration(
            color: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13 * pixel),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 10 * pixel),
              Center(
                child: Text(
                  "날짜 선택",
                  style: TextStyle(
                      fontSize: 14 * pixel,
                      color: Color(0x7F191F28),
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5 * pixel),
              SizedBox(
                height: 180 * pixel,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date, // 날짜 선택 모드
                  initialDateTime: _selectedDate ?? DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    _selectedDate = newDate;
                  },
                ),
              ),
              Divider(
                height: 10.0 * pixel, // margin top & bottom
                color: Colors.grey[850],
                thickness: 0.5 * pixel,
              ),
              CupertinoButton(
                onPressed: () {
                  onSelected(_selectedDate);

                  print("선택된 날짜: $_selectedDate");
                },
                child: Text(
                  '확인',
                  style: TextStyle(
                    color: Color(0xFF007AFF),
                    fontSize: 20 * pixel,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8 * pixel),
        Container(
          width: 377 * pixel,
          height: 57 * pixel,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13 * pixel),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                  onPressed: () => Navigator.pop(context), // 취소 버튼
                  child: Center(
                    child: Text(
                      '취소',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF007AFF),
                        fontSize: 20 * pixel,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )),
            ],
          ),
        ),
        SizedBox(
          height: 36 * pixel,
        ),
      ],
    );
  }
}
