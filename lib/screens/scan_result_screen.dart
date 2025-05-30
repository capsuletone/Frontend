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
  bool hasSaved = false; // ✅ 중복 저장 방지

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!hasSaved) {
        hasSaved = true;
        final userId = context.read<EmailProvider>().email;

        processAndSaveUserData(
          userId: userId,
          date: widget.result.date,
          diseaseCode: widget.result.diseaseCode ?? '알수없음',
          medicineName: widget.result.medicineName,
          dosesPerDay: widget.result.dosesPerDay,
          totalDays: widget.result.totalDays,
        );

        setState(() {}); // ✅ items가 추가된 후 리빌드
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;

    final minLength = [
      widget.result.medicineName.length,
      widget.result.dosesPerDay.length,
      widget.result.totalDays.length,
    ].reduce((a, b) => a < b ? a : b); // ✅ 배열 길이 불일치 방지

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
            Text(" 질병 코드: ${widget.result.diseaseCode ?? '알수없음'}",
                style: TextStyle(fontSize: 18, color: Colors.black)),
            SizedBox(height: 20),
            Text("💊 약 정보:",
                style: TextStyle(
                    fontSize: 20 * pixel,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            SizedBox(height: 20 * pixel),
            ...List.generate(minLength, (index) {
              final name = widget.result.medicineName[index];
              final dose = _parseDose(widget.result.dosesPerDay[index]);
              final days = _parseDays(widget.result.totalDays[index]);

              return Container(
                margin: EdgeInsets.symmetric(vertical: 4 * pixel),
                padding: EdgeInsets.all(12 * pixel),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8 * pixel),
                ),
                child: Text(
                  "$name | 1일 ${dose}회 | ${days}일 복용",
                  style: TextStyle(fontSize: 16 * pixel, color: Colors.black),
                ),
              );
            }),
            Spacer(),
            GestureDetector(
              onTap: () async {
                if (items.isNotEmpty) {
                  saveUserRepository.saveUserData(items, context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('저장할 데이터가 없습니다.')),
                  );
                }
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
            SizedBox(height: 18 * pixel),
          ],
        ),
      ),
    );
  }

  // ✅ 복용 횟수에 따른 시간대 계산
  List<String> _getTimesByDoses(double doses) {
    if (doses == 3.0) return ['아침', '점심', '저녁'];
    if (doses == 2.0) return ['아침', '저녁'];
    if (doses == 1.0) return ['점심'];
    return ['알수없음'];
  }

  // ✅ 유저 데이터 가공 및 저장용 리스트 구성
  void processAndSaveUserData({
    required String? userId,
    required String? date,
    required String diseaseCode,
    required List<dynamic> medicineName,
    required List<dynamic> dosesPerDay,
    required List<dynamic> totalDays,
  }) {
    final formattedDate = "$date";
    final Set<String> addedMedicineNames = {};

    final minLength = [
      medicineName.length,
      dosesPerDay.length,
      totalDays.length
    ].reduce((a, b) => a < b ? a : b);

    for (int i = 0; i < minLength; i++) {
      final name = medicineName[i];
      final dose = _parseDose(dosesPerDay[i]).toDouble();
      final days = _parseDays(totalDays[i]);

      if (addedMedicineNames.contains(name)) continue;
      addedMedicineNames.add(name);

      final times = _getTimesByDoses(dose).join(", ");

      final data = SaveUserDatabase(
        userid: userId ?? '',
        diseaseCode: diseaseCode,
        medicineName: name,
        time: times,
        totalDays: days,
        date: formattedDate,
      );

      items.add(data);
    }
  }

  // ✅ 복용 횟수 파싱
  int _parseDose(dynamic dose) {
    if (dose is int) return dose;
    if (dose is double) return dose.toInt();
    if (dose is String) return int.tryParse(dose) ?? 0;
    return 0;
  }

  // ✅ 복용 일수 파싱
  int _parseDays(dynamic days) {
    if (days is int) return days;
    if (days is double) return days.toInt();
    if (days is String) return int.tryParse(days) ?? 0;
    return 0;
  }
}
