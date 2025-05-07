import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../database/saveuser_request_database.dart';
import '../repository/saveuserdata_repository.dart';
import 'prescription_manually_add_screen.dart';

class PrescriptionManuallyScreen extends StatefulWidget {
  const PrescriptionManuallyScreen({super.key});

  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionManuallyScreen> {
  List<SaveUserDatabase> items = [];

  final saveUserRepository = SaveuserdataRepository();
  // 항목 추가 함수
  void addItem(SaveUserDatabase item) {
    setState(() {
      items.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          // 리스트가 비었을 때와 있을 때 보여주는 화면 분기
          GestureDetector(
            onTap: () {
              context.go('/root');
            },
            child: const Text("뒤로가기"),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text(
                      "약 정보가 없어요",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('약 이름: ${item.medicineName ?? "없음"}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            const SizedBox(height: 4),
                            Text('질병 코드: ${item.diseaseCode ?? "-"}',
                                style: const TextStyle(color: Colors.black87)),
                            Text('복용 주기: ${item.totalDays ?? "-"}일',
                                style: const TextStyle(color: Colors.black87)),
                            Text('복용 시작일: ${item.date ?? "-"}',
                                style: const TextStyle(color: Colors.black87)),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          GestureDetector(
            onTap: () async {
              final newItem = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddMedicineItemScreen()),
              );

              if (newItem != null && newItem is SaveUserDatabase) {
                addItem(newItem);
              }
            },
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.green[400],
                child: Text("추가하기",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17 * pixel,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ))),
          ),
          SizedBox(
            height: 30 * pixel,
          ),
          GestureDetector(
            onTap: () async {
              saveUserRepository.saveUserData(items, context);
            },
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.green[400],
                child: Text("작성 완료하기",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17 * pixel,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ))),
          ),
        ]),
      ),
    );
  }
}
