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
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24 * pixel),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 54 * pixel),

              ///  Back Button
              GestureDetector(
                onTap: () => context.go('/root'),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 24.0 * pixel,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 34 * pixel),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.medication_outlined,
                                size: 64, color: Colors.grey[400]),
                            SizedBox(height: 12),
                            const Text(
                              "약 정보가 없어요",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 12 * pixel),
                            padding: EdgeInsets.all(16 * pixel),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12 * pixel),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6 * pixel,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '약 이름: ${item.medicineName ?? "없음"}',
                                  style: TextStyle(
                                    fontSize: 16 * pixel,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 6 * pixel),
                                Text('질병 코드: ${item.diseaseCode ?? "-"}',
                                    style: TextStyle(
                                        fontSize: 14 * pixel,
                                        color: Colors.black87)),
                                Text('복용 주기: ${item.totalDays ?? "-"}일',
                                    style: TextStyle(
                                        fontSize: 14 * pixel,
                                        color: Colors.black87)),
                                Text('시작일: ${item.date ?? "-"}',
                                    style: TextStyle(
                                        fontSize: 14 * pixel,
                                        color: Colors.black87)),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              SizedBox(height: 16 * pixel),
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
                  padding: EdgeInsets.symmetric(vertical: 16 * pixel),
                  decoration: BoxDecoration(
                    color: Colors.green[300],
                    borderRadius: BorderRadius.circular(12 * pixel),
                  ),
                  child: Text(
                    "추가하기",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17 * pixel,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15 * pixel),

              /// ✅ 완료하기 버튼
              GestureDetector(
                onTap: () async {
                  saveUserRepository.saveUserData(items, context);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16 * pixel),
                  decoration: BoxDecoration(
                    color: Colors.green[500],
                    borderRadius: BorderRadius.circular(12 * pixel),
                  ),
                  child: Text(
                    "작성 완료하기",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17 * pixel,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 34 * pixel),
            ],
          ),
        ),
      ),
    );
  }
}
