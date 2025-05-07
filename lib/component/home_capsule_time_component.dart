import 'package:flutter/material.dart';
import '../database/requestuser_response_extentions_database.dart';
import '../screens/capsule_detail_screen.dart';

Widget homeCapsuleTimeContainer(
    double pixel, List<RequestuserResponseExtentionsDatabase> diseaseList) {
  double widthSize = 400 * pixel;
  double heightSize = 600 * pixel;
  double fontSize = 24.0 * pixel; // 글자 크기 설정
  double spacing = 30.0 * pixel; // 두 텍스트 사이의 간격 설정
  double itemHeight = (heightSize - 16 * pixel * 3) /
      5; // 아이템 크기 계산 (패딩을 제외한 나머지 공간을 아이템 개수로 나눔)
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
    width: widthSize, // 가로 크기
    height: heightSize, // 세로 크기
    padding: EdgeInsets.all(16 * pixel),
    color: Colors.green[300], // 배경색
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '현재 복용중인 약',
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16 * pixel),
        Expanded(
          child: ListView.builder(
            itemCount: allMedicineNames.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 8.0 * pixel), // 각 Row 간의 간격 설정
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CapsuleDetailScreen(
                                itemName: allMedicineNames[index]),
                          ),
                        );
                      },
                      child: Container(
                          child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30, // 원형 아바타 크기
                            backgroundImage: NetworkImage(''), // 아바타 이미지 URL
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('약 이름: ${allMedicineNames[index]}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text('설명: ${allMedicineDescription[index]}',
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ],
                      ))));
            },
          ),
        ),
      ],
    ),
  );
}
