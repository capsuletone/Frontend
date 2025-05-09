import 'package:capsuleton_flutter/database/login_database.dart';
import 'package:capsuleton_flutter/database/requestuser_request_database.dart';
import 'package:capsuleton_flutter/repository/requestUser_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../component/auth_login_button.dart';
import '../component/auth_login_text_field.dart';
import '../component/show_error_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  void signUserIn() async {
    // 입력 유효성 검사
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ShowErrorMessage(
              context: context,
              message: 'Email and password must not be empty.')
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
    } on FirebaseAuthException catch (e) {
      ShowErrorMessage(context: context, message: e.code).show();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // 포커스 해제 및 키보드 내리기
        },
        child: Scaffold(
            backgroundColor: Colors.green[100],
            body: LayoutBuilder(builder: (context, constraints) {
              final isScrollable = constraints.maxHeight < 600;
              final screenWidth = MediaQuery.of(context).size.width; // 화면 너비
              final isTablet = screenWidth >= 768; // 아이패드 여부 판단

              final content = Container(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 33 * pixel),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                child: Column(
                              children: [
                                if (!isTablet &&
                                    !isScrollable) // isScrollable이 false일 때만 SizedBox 적용
                                  SizedBox(
                                    height: 239 * pixel,
                                  ),
                                Icon(
                                  Icons.medication, // 원하는 아이콘 설정
                                  size: 200 * pixel, // 크기 조절
                                  color: Colors.white, // 색상 지정
                                )
                              ],
                            )),
                            SizedBox(
                              height: 100 * pixel,
                            ),
                            LoginTextField(
                              controller: emailController,
                              hintText: '아이디',
                              obscureText: false,
                            ),
                            SizedBox(
                              height: 20 * pixel,
                            ),
                            LoginTextField(
                              controller: passwordController,
                              hintText: '비밀번호',
                              obscureText: true,
                            ),
                            SizedBox(
                              height: 20 * pixel,
                            ),
                            LoginButton(
                              text: _isLoading ? "" : "로그인",
                              onTap: _isLoading ? null : signUserIn,
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.green)
                                  : null,
                            ),
                            SizedBox(
                              height: 40 * pixel,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '로그인 정보가 없으면?',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    context.go(
                                        '/register'); // Here we use context.go() instead of Navigator
                                  },
                                  child: const Text(
                                    '회원가입',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40 * pixel,
                            ),
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
