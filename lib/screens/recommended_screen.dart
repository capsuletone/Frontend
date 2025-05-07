import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecommendedScreen extends StatefulWidget {
  const RecommendedScreen({super.key});

  @override
  State<RecommendedScreen> createState() => _RecommendedScreenState();
}

class _RecommendedScreenState extends State<RecommendedScreen> {
  final List<String> _symptoms = ['콧물', '가래', '기침', '목 아픔', '두통', '발열'];
  final List<String> _selectedSymptoms = [];
  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, dynamic>? _parsedJson;

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.remove(symptom);
      } else {
        _selectedSymptoms.add(symptom);
      }
    });
  }

  Future<void> _submitSymptoms() async {
    if (_selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('증상을 한 개 이상 선택해주세요!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _parsedJson = null;
      _errorMessage = '';
    });

    final String symptomsData = _selectedSymptoms.join(', ');
    final Uri uri = Uri.parse('http://10.0.2.2:8080/chat'); // Emulator 전용 IP

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userMessage': symptomsData}),
      );

      if (response.statusCode == 200) {
        final cleaned = response.body.trim();

        // ''' 또는 ```json 제거
        final cleanedJson = cleaned
            .replaceAll("'''", '')
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        try {
          final parsed = json.decode(cleanedJson);
          setState(() {
            _isLoading = false;
            _parsedJson = parsed;
          });
        } catch (e) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'JSON 파싱 실패: $e';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = '서버 오류: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = '네트워크 오류: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('증상 선택 & AI 가이드')),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(30 * pixel),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '현재 앓고 있는 증상을 선택하세요',
                style: TextStyle(
                    fontSize: 18 * pixel, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children: _symptoms.map((symptom) {
                  final isSelected = _selectedSymptoms.contains(symptom);
                  return ElevatedButton(
                    onPressed: () => _toggleSymptom(symptom),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.blue : Colors.white,
                      foregroundColor: isSelected ? Colors.white : Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    child: Text(symptom),
                  );
                }).toList(),
              ),
              SizedBox(height: 20 * pixel),
              Text(
                '선택한 증상: ${_selectedSymptoms.isNotEmpty ? _selectedSymptoms.join(', ') : '없음'}',
                style: TextStyle(fontSize: 16 * pixel),
              ),
              SizedBox(height: 30 * pixel),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitSymptoms,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15 * pixel),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('증상 전송 및 AI 가이드 받기',
                        style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 30 * pixel),
              if (_parsedJson != null) ...[
                _buildGuidelines(_parsedJson!['guideline']),
                SizedBox(height: 20 * pixel),
                _buildMedicines(_parsedJson!['medicines']),
                SizedBox(height: 20 * pixel),
                _buildNote(_parsedJson!['note'],
                    _parsedJson!['additional_warning'] ?? ""),
              ],
              if (_errorMessage.isNotEmpty) ...[
                SizedBox(height: 20 * pixel),
                const Text('오류:',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
                Text(_errorMessage, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuidelines(List<dynamic> guidelines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('생활 가이드라인',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...guidelines.map((g) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text("• $g"),
            )),
      ],
    );
  }

  Widget _buildMedicines(List<dynamic> medicines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('추천 약품',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...medicines.map((m) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("설명: ${m['description']}"),
                    Text("복용 방법: ${m['usage']}"),
                    Text("주의사항: ${m['caution']}"),
                    Text("추천도: ${m['confidence']}"),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildNote(String note, String additionalWarning) {
    final isWarning = additionalWarning.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('주의사항 및 진료 권고',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (isWarning)
          Container(
            decoration: BoxDecoration(
              color: Colors.amber[100],
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Colors.orange, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    additionalWarning,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Text(note),
      ],
    );
  }
}
