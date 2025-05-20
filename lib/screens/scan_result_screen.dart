import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/naver_ocr_response_database.dart';
import '../database/saveuser_request_database.dart';
import '../provider/email_provider.dart';
import '../repository/saveuserdata_repository.dart';

class OcrresultPage extends StatefulWidget {
  final NaverOcrResponseDatabase result;

  const OcrresultPage({Key? key, required this.result}) : super(key: key);

  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<OcrresultPage> {
  List<SaveUserDatabase> items = [];
  final saveUserRepository = SaveuserdataRepository();

  bool hasSaved = false; // ✅ 저장 중복 방지

  @override
  void initState() {
    super.initState();

    // 저장은 딱 한 번만 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!hasSaved) {
        hasSaved = true;
        processAndSaveUserData(
          userId: context.read<EmailProvider>().email,
          date: widget.result.date,
          diseaseCode: widget.result.diseaseCode!,
          medicineName: widget.result.medicineName,
          dosesPerDay: widget.result.dosesPerDay,
          totalDays: widget.result.totalDays,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;

    return Scaffold(
      appBar: AppBar(
        title: Text('처방 결과'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0 * pixel),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(" 날짜: ${widget.result.date}",
                style: TextStyle(fontSize: 18, color: Colors.black)),
            SizedBox(height: 4),
            Text(" 질병 코드: ${widget.result.diseaseCode}",
                style: TextStyle(fontSize: 18, color: Colors.black)),
            SizedBox(height: 20),
            Text("💊 약 정보:",
                style: TextStyle(
                    fontSize: 20 * pixel,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            SizedBox(height: 20 * pixel),
            ...List.generate(widget.result.medicineName.length, (index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 4 * pixel),
                padding: EdgeInsets.all(12 * pixel),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8 * pixel),
                ),
                child: Text(
                  "${widget.result.medicineName[index]} | 1일 ${widget.result.dosesPerDay[index].toInt()}회 | ${widget.result.totalDays[index]}일 복용",
                  style: TextStyle(fontSize: 16 * pixel, color: Colors.black),
                ),
              );
            }),
            Spacer(),
            GestureDetector(
              onTap: () async {
                saveUserRepository.saveUserData(items, context);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16 * pixel),
                decoration: BoxDecoration(
                  color: Colors.green[400],
                  borderRadius: BorderRadius.circular(12 * pixel),
                ),
                child: Text(
                  "작성 완료하기",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17 * pixel,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 18 * pixel,
            ),
          ],
        ),
      ),
    );
  }

  // 복용 시간대 계산
  List<String> _getTimesByDoses(double doses) {
    if (doses == 3.0) {
      return ['아침', '점심', '저녁'];
    } else if (doses == 2.0) {
      return ['아침', '저녁'];
    } else if (doses == 1.0) {
      return ['점심'];
    } else {
      return ['알수없음'];
    }
  }

  // 유저 데이터 저장 처리
  void processAndSaveUserData({
    required String? userId,
    required String? date,
    required String diseaseCode,
    required List<dynamic> medicineName,
    required List<dynamic> dosesPerDay,
    required List<dynamic> totalDays,
  }) {
    final formattedDate = "$date";
    final Set<String> addedMedicineNames = {}; // ✅ 중복 방지용 Set

    for (int i = 0; i < medicineName.length; i++) {
      final name = medicineName[i];
      final doses = dosesPerDay[i] ?? 0;
      final days = totalDays[i] ?? 0;

      // ✅ 약 이름 중복 검사
      if (addedMedicineNames.contains(name)) {
        continue; // 중복이면 건너뜀
      }
      addedMedicineNames.add(name);

      // ✅ 복용 시간대 계산
      List<String> times = _getTimesByDoses(doses);

      // "아침", "점심", "저녁"을 하나의 객체에 저장하기 위해
      // 여러 시간대를 하나의 "time" 값에 담기
      final timeString = times.join(", "); // "아침, 점심, 저녁" 형태로 합침

      // 하나의 데이터 객체로 저장
      final data = SaveUserDatabase(
        userid: userId ?? '',
        diseaseCode: diseaseCode,
        medicineName: name,
        time: timeString, // 시간대들을 쉼표로 구분하여 하나의 필드에 저장
        totalDays: days,
        date: formattedDate,
      );

      items.add(data); // 중복 아닌 경우에만 추가
    }

    // ✅ 모든 데이터 수집 후 한 번만 저장 호출
  }

  // 실제 저장 처리 (지금은 print로 확인)
  void saveUserData(Map<String, dynamic> data) {
    print("💾 Saving user data: $data");
  }
}
