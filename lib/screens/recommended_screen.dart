import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecommendedScreen extends StatefulWidget {
  const RecommendedScreen({super.key});

  @override
  State<RecommendedScreen> createState() => _RecommendedScreenState();
}

class _RecommendedScreenState extends State<RecommendedScreen> {
  List<String> _symptoms = ['콧물', '가래', '기침', '목 아픔', '두통', '발열'];
  List<String> _selectedSymptoms = [];
  bool _isLoading = false;
  String _responseText = '';
  String _errorMessage = '';

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
      _responseText = 'AI 가이드라인을 요청 중입니다...';
      _errorMessage = '';
    });

    final String symptomsData = _selectedSymptoms.join(', ');
    // Android Studio 에뮬레이터에서 로컬 Spring Boot 서버에 접근하기 위한 IP 주소
    final Uri uri = Uri.parse('http://10.0.2.2:8080/chat');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userMessage': symptomsData}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
          _responseText = response.body;
        });
      } else {
        setState(() {
          _isLoading = false;
          _responseText = 'AI 응답을 받는 데 실패했습니다. (HTTP 상태 코드: ${response.statusCode})\n${response.body}';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _responseText = '네트워크 오류가 발생했습니다: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('증상 선택 & AI 가이드'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(30 * pixel),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '현재 앓고 있는 증상을 선택하세요',
                style: TextStyle(fontSize: 18 * pixel, fontWeight: FontWeight.bold),
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
                      side: BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('증상 전송 및 AI 가이드 받기', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 30 * pixel),
              Text(
                'AI 가이드라인:',
                style: TextStyle(fontSize: 16 * pixel, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10 * pixel),
              Text(
                _responseText,
                style: TextStyle(fontSize: 14 * pixel),
              ),
              if (_errorMessage.isNotEmpty) ...[
                SizedBox(height: 20 * pixel),
                Text(
                  '오류:',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                Text(_errorMessage, style: TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}