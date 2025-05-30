import 'package:capsuleton_flutter/database/saveuser_request_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../component/prescription_maunally_add_compoennt.dart';
import '../component/prescription_passivit_add_date_component.dart';
import '../provider/email_provider.dart';

class AddMedicineItemScreen extends StatefulWidget {
  final Function()? onTap;
  const AddMedicineItemScreen({super.key, this.onTap});

  @override
  State<AddMedicineItemScreen> createState() => _AddMedicineItemScreenState();
}

class _AddMedicineItemScreenState extends State<AddMedicineItemScreen> {
  String? _storedTotalDays;
  String? _formattedDate;
  final TextEditingController _diseaseCodecontroller =
      TextEditingController(); //질병코드
  final TextEditingController _medicineNamecontroller =
      TextEditingController(); //약이름
  final TextEditingController _timecontroller =
      TextEditingController(); //허루 복용 시간
  final TextEditingController _totalDayscontroller =
      TextEditingController(); //복용 주기
  final TextEditingController _dateCodecontroller =
      TextEditingController(); //시작일

  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(builder: (context, constraints) {
          final isScrollable = constraints.maxHeight < 600;
          final screenWidth = MediaQuery.of(context).size.width;
          final isTablet = screenWidth >= 768;
          final pixel = screenWidth / 375 * 0.97;

          final content = Padding(
            padding: EdgeInsets.symmetric(horizontal: 24 * pixel),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      SizedBox(height: kIsWeb ? 24 * pixel : 54 * pixel),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 23.0 * pixel,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 12 * pixel),
                          Text(
                            '약 추가',
                            style: TextStyle(
                              fontSize: 25 * pixel,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Pretendard',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32 * pixel),

                      /// 약 정보 입력 필드들
                      buildInputField(
                          "질병코드", _diseaseCodecontroller, "ex) R51", pixel),
                      buildInputField(
                          "약 이름", _medicineNamecontroller, "ex) 타이레놀", pixel),
                      buildInputField(
                          "복용 횟수", _timecontroller, "ex) 아침,점심,저녁", pixel),
                      buildInputField(
                          "복용 주기", _totalDayscontroller, "ex) 3", pixel,
                          keyboardType: TextInputType.number,
                          onChanged: (text) {
                        if (text.isNotEmpty && !text.endsWith('일')) {
                          _totalDayscontroller.text = '$text';
                          _totalDayscontroller.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: _totalDayscontroller.text.length),
                          );
                        }
                        _storedTotalDays = text;
                      }),

                      Text("복용 시작 일",
                          style: TextStyle(
                            fontSize: 16 * pixel,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Pretendard',
                            color: Colors.black,
                          )),
                      SizedBox(height: 8 * pixel),
                      GestureDetector(
                        onTap: () async {
                          final selectedDate =
                              await showModalBottomSheet<DateTime>(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (_) => DateEditPopupContainer(
                              onSelected: (date) =>
                                  Navigator.pop(context, date),
                            ),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              _formattedDate =
                                  DateFormat('yyyy-MM-dd').format(selectedDate);
                              _dateCodecontroller.text = _formattedDate!;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12 * pixel, vertical: 14 * pixel),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _formattedDate ?? '날짜 선택',
                            style: TextStyle(
                                fontSize: 16 * pixel,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54),
                          ),
                        ),
                      ),
                    ])),
                Container(
                  child: Column(children: [
                    GestureDetector(
                      onTap: () {
                        final newItem = SaveUserDatabase(
                          userid: context.read<EmailProvider>().email,
                          diseaseCode: _diseaseCodecontroller.text,
                          medicineName: _medicineNamecontroller.text,
                          time: _timecontroller.text,
                          totalDays: int.tryParse(_storedTotalDays ?? '0'),
                          date: _dateCodecontroller.text,
                        );
                        Navigator.pop(context, newItem);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.green[400],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "완료",
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
                  ]),
                )
              ],
            ),
          );

          return SingleChildScrollView(
              physics:
                  isScrollable ? null : const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: content,
              ));
        }),
      ),
    );
  }
}
