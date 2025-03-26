import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../component/date_picker_popup_component.dart';
import 'package:intl/intl.dart';

import '../component/highlight_text_component.dart';
import '../component/home_qrcode_scan_component.dart';

class PrescriptionAddScreen extends StatefulWidget {
  final Function()? onTap;
  const PrescriptionAddScreen({super.key, this.onTap});

  @override
  State<PrescriptionAddScreen> createState() => _PrescriptionAddScreenState();
}

class _PrescriptionAddScreenState extends State<PrescriptionAddScreen> {
  String? _formattedDate;
  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;
    if (_formattedDate == null) {
      _formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // 포커스 해제 및 키보드 내리기
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: LayoutBuilder(builder: (context, constraints) {
              final isScrollable = constraints.maxHeight < 600;
              final screenWidth = MediaQuery.of(context).size.width; // 화면 너비
              final isTablet = screenWidth >= 768; // 아이패드 여부 판단

              final content = Padding(
                  padding: EdgeInsets.all(16.0 * pixel),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 54 * pixel),
                        highlightText(pixel, context, "약 추가"),
                        SizedBox(height: 24 * pixel),
                        homeQrcodeScanContainer(() {
                          context.go('/root/prescriptionEdit');
                        }, pixel, Colors.green[300], "처방전으로 약 추가"),
                        SizedBox(
                          height: 20 * pixel,
                        ),
                        homeQrcodeScanContainer(() {
                          context
                              .go('/root/preescriptionAdd/preescriptionResult');
                        }, pixel, Colors.green[400], "수동으로 약 추가"),
                      ]));

              return SingleChildScrollView(
                  physics: isScrollable ? null : NeverScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: content,
                  ));
            })));
  }
}
