import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateEditPopupContainer extends StatelessWidget {
  final Function(DateTime) onSelected;

  DateEditPopupContainer({super.key, required this.onSelected});

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final pixel = screenWidth / 375 * 0.97;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth > 600 ? 500 : double.infinity, // 웹/태블릿에서 최대 너비
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 12 * pixel,
              ),
              width: 400 * pixel,
              height: 340 * pixel, // 살짝 키움
              decoration: ShapeDecoration(
                color: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13 * pixel),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 16 * pixel),
                  Text(
                    "날짜 선택",
                    style: TextStyle(
                      fontSize: 16 * pixel,
                      color: const Color(0xFF191F28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12 * pixel),
                  SizedBox(
                    height: 200 * pixel, // 높이 살짝 키움
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: _selectedDate ?? DateTime.now(),
                      onDateTimeChanged: (DateTime newDate) {
                        _selectedDate = newDate;
                      },
                    ),
                  ),
                  Divider(
                    height: 14.0 * pixel,
                    color: Colors.grey[850],
                    thickness: 0.5 * pixel,
                  ),
                  CupertinoButton(
                    onPressed: () => onSelected(_selectedDate),
                    child: Text(
                      '확인',
                      style: TextStyle(
                        fontSize: 22 * pixel,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10 * pixel),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 12 * pixel,
              ),
              width: double.infinity,
              height: 60 * pixel,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13 * pixel),
                ),
              ),
              child: Center(
                child: CupertinoButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    '취소',
                    style: TextStyle(
                      fontSize: 20 * pixel,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40 * pixel),
          ],
        ),
      ),
    );
  }
}
