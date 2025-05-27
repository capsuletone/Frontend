import 'package:capsuleton_flutter/repository/register_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../component/auth_login_button.dart';
import '../component/auth_login_text_field.dart';
import '../component/show_error_message.dart';
import '../database/register_database.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // text editing controllers

  final registerRepository = RegisterRepository();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  bool _isLoading = false; // 로딩 상태를 추적하는 변수

  // sign user up method

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;
    Future signUserUp() async {
      // 입력 유효성 검사 추가
      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          userNameController.text.isEmpty) {
        ShowErrorMessage(
                pixel: pixel, context: context, message: '모든 칸을 작성 완료하십시요.')
            .show();
        return;
      }

      setState(() {
        _isLoading = true; // 로딩 상태 관리를 위한 상태 변수 설정
      });

      try {
        final register = Register(
          userid: emailController.text,
          password: passwordController.text,
          username: userNameController.text,
          registerdate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        );
        await registerRepository.registerUser(register, context);
      } catch (e) {
        print("에러 발생 $e");
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false; // 로딩 상태 관리를 위한 상태 변수 설정
          });
        }
      }
    }

    return Scaffold(
        backgroundColor: Colors.green[100],
        body: LayoutBuilder(builder: (context, constraints) {
          final isScrollable = constraints.maxHeight < 600;
          final screenWidth = MediaQuery.of(context).size.width; // 화면 너비
          final isTablet = screenWidth >= 768; // 아이패드 여부 판단

          final content = Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24 * pixel),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 100 * pixel,
                            height: 100 * pixel,
                            decoration: BoxDecoration(
                              color: Colors.green[300],
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                )
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Icon(FontAwesomeIcons.pills,
                                size: 60 * pixel, color: Colors.white)),

                        SizedBox(height: 30 * pixel),

                        Text(
                          '캡슐톤에 가입하고 다양한 정보를 만나보세요!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: 30 * pixel),

                        // 입력 필드들
                        LoginTextField(
                          controller: emailController,
                          hintText: '아이디',
                          obscureText: false,
                        ),
                        SizedBox(height: 12 * pixel),
                        LoginTextField(
                          controller: passwordController,
                          hintText: '비밀번호',
                          obscureText: true,
                        ),
                        SizedBox(height: 12 * pixel),
                        LoginTextField(
                          controller: userNameController,
                          hintText: '닉네임',
                          obscureText: false,
                        ),

                        SizedBox(height: 30 * pixel),

                        // 회원가입 버튼
                        LoginButton(
                          text: _isLoading ? "" : "회원가입",
                          onTap: _isLoading ? null : signUserUp,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : null,
                        ),

                        const SizedBox(height: 60),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '이미 계정이 있으신가요?',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                context.go('/login');
                              },
                              child: const Text(
                                '로그인',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20 * pixel),
                      ])));

          return SingleChildScrollView(
              physics:
                  isScrollable ? null : const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: content,
              ));
        }));
  }
}
