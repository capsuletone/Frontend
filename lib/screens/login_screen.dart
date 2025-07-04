import 'package:capsuleton_flutter/database/login_database.dart';
import 'package:capsuleton_flutter/database/requestuser_request_database.dart';
import 'package:capsuleton_flutter/repository/requestUser_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../component/auth_login_button.dart';
import '../component/auth_login_text_field.dart';
import '../component/responsive_Wrapper.dart';
import '../component/show_error_message.dart';
import '../provider/email_provider.dart';
import '../repository/login_repository.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginRepository = LoginRepository();
  final requestRepository = RequestuserRepository();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;

    Future<void> signUserIn() async {
      // 입력 유효성 검사
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        ShowErrorMessage(
                pixel: pixel, context: context, message: '모든 칸을 작성 완료하십시요.')
            .show();
        return;
      }

      try {
        final loginData = Login(
            userid: emailController.text, password: passwordController.text);
        loginRepository.loginUser(loginData, context);
        final reuqestData =
            RequestuserRequestDatabase(userid: emailController.text);
        context.read<EmailProvider>().updateEmail(emailController.text);
        requestRepository.requestUser(reuqestData, context);
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // 포커스 해제 및 키보드 내리기
        },
        child: Scaffold(
            backgroundColor: Colors.green[100],
            body: LayoutBuilder(builder: (context, constraints) {
              final isScrollable = constraints.maxHeight < 600;
              final screenWidth = MediaQuery.of(context).size.width;
              final isTablet = screenWidth >= 768;
              final pixel = screenWidth / 375 * 0.97;
              final content = Center(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24 * pixel),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                child: Column(children: [
                              Icon(
                                Icons.medication,
                                size: 200 * pixel,
                                color: Colors.white,
                              )
                            ])),
                            SizedBox(height: 20 * pixel),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    width: 340 * pixel,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20 * pixel,
                                        horizontal: 24 * pixel),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10 * pixel,
                                          spreadRadius: 2,
                                          offset: Offset(0, 4),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        LoginTextField(
                                          controller: emailController,
                                          hintText: '아이디',
                                          obscureText: false,
                                        ),
                                        SizedBox(height: 16 * pixel),
                                        LoginTextField(
                                          controller: passwordController,
                                          hintText: '비밀번호',
                                          obscureText: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 24 * pixel),
                                  LoginButton(
                                    text: _isLoading ? "" : "로그인",
                                    onTap: _isLoading ? null : signUserIn,
                                    child: _isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.green)
                                        : null,
                                  ),
                                  SizedBox(height: 24 * pixel),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '로그인 정보가 없으면?',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14 * pixel,
                                        ),
                                      ),
                                      SizedBox(width: 6 * pixel),
                                      GestureDetector(
                                        onTap: () {
                                          context.go('/register');
                                        },
                                        child: Text(
                                          '회원가입',
                                          style: TextStyle(
                                            color: Colors.green[400],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14 * pixel,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 60 * pixel),
                                ],
                              ),
                            )
                          ])));

              return SingleChildScrollView(
                  physics: isScrollable
                      ? null
                      : const NeverScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: content,
                  ));
            })));
  }
}
