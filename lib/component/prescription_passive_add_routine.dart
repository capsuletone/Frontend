import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PetSexEditPopupContainer extends StatefulWidget {
  final void Function(String) onSelected;
  final String selectedGender; // 현재 선택된 성별을 전달받음

  PetSexEditPopupContainer({
    required this.onSelected,
    required this.selectedGender, // 선택된 값 반영
  });

  @override
  _PetSexEditPopupContainerState createState() =>
      _PetSexEditPopupContainerState();
}

class _PetSexEditPopupContainerState extends State<PetSexEditPopupContainer> {
  final List<String> texts = ["남아", "여아", "미구분"];
  String? selectedText; // 선택된 텍스트 저장

  @override
  void initState() {
    super.initState();
    selectedText = widget.selectedGender; // 초기 선택값 설정
  }

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 393 * 0.97;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12 * pixel),
          topRight: Radius.circular(12 * pixel),
        ),
      ),
      child: Container(
        height: 200 * pixel, // ✅ 전체 팝업 높이 고정
        padding: EdgeInsets.symmetric(horizontal: 16 * pixel),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16 * pixel),
            Text(
              '성별 선택',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18 * pixel,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12 * pixel),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: texts.map((text) {
                    return Column(
                      children: [
                        SizedBox(height: 17 * pixel),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedText = text;
                            });
                            widget.onSelected(text);
                          },
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 18 * pixel,
                              fontWeight: FontWeight.bold,
                              color: selectedText == text
                                  ? Colors.black
                                  : Color(0x7F191F28),
                            ),
                          ),
                        ),
                        SizedBox(height: 17 * pixel),
                        if (text != "미구분")
                          Container(
                            width: 349 * pixel,
                            height: 1.0 * pixel,
                            color: Colors.grey[300],
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
