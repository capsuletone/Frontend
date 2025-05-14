import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../database/requestuser_response_extentions_database.dart';
import '../screens/capsule_detail_screen.dart';

Widget homeCapsuleTimeContainer(
    double pixel, List<RequestuserResponseExtentionsDatabase> diseaseList) {
  double widthSize = 400 * pixel;
  double heightSize = 600 * pixel;
  double fontSize = 24.0 * pixel; // 글자 크기 설정
  List<String> allMedicineNames = [];
  List<String> allMedicineDescription = [];

  DateTime stripTime(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  final DateTime today = stripTime(DateTime.now());

  for (var disease in diseaseList) {
    for (var med in disease.medicines!) {
      DateTime startDate = stripTime(DateTime.parse(med.date));
      DateTime endDate =
          stripTime(startDate.add(Duration(days: med.totalDays - 1)));

      if (!today.isBefore(startDate) && !today.isAfter(endDate)) {
        allMedicineNames.add(med.medicineName);
        allMedicineDescription.add(med.time);
      }
    }
  }

  print("오늘 복용 약: $allMedicineNames");
  print("복용 시간: $allMedicineDescription");

  print("오늘 복용 약: $allMedicineDescription");
  return Container(
    width: widthSize,
    height: heightSize,
    padding: EdgeInsets.all(16 * pixel),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20 * pixel),
      boxShadow: [
        // 아래쪽 그림자
        BoxShadow(
          color: Colors.black26,
          blurRadius: 12 * pixel,
          offset: Offset(0, 20),
        ),
        // 위쪽 그림자
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8 * pixel,
          offset: Offset(0, -10),
        ),
        // 왼쪽 그림자
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8 * pixel,
          offset: Offset(-10, 0),
        ),
        // 오른쪽 그림자 (선택적으로)
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8 * pixel,
          offset: Offset(10, 0),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '오늘,',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[800], // 강조 색
                ),
              ),
              TextSpan(
                text: '복용할 약이에요',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30 * pixel),
        Expanded(
          child: allMedicineNames.isEmpty
              ? Center(
                  child: Text(
                    "약 정보가 없습니다.\n추가 페이지에서 약을 등록하세요",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15 * pixel,
                      color: Colors.grey[500],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: 10 * pixel),
                  itemCount: allMedicineNames.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CapsuleDetailScreen(
                              itemName: allMedicineNames[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12 * pixel),
                        padding: EdgeInsets.all(12 * pixel),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.green[300],
                                child: Icon(FontAwesomeIcons.pills,
                                    size: 25 * pixel, color: Colors.white)),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${allMedicineNames[index]}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${allMedicineDescription[index]}',
                                    style: TextStyle(
                                      fontSize: 14 * pixel,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}
