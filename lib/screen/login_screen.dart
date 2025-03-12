import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../auth/component/login_button.dart';
import '../auth/component/login_text_field.dart';
import '../auth/component/show_error_message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(emailController.text)) {
      // 이메일 형식이 올바르지 않으면 에러 메시지를 표시합니다.
      ShowErrorMessage(
        context: context,
        message: 'Please enter a valid email address.',
      ).show();
    }
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      context.go('/');
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

    return GestureDetector(onTap: () {
      FocusScope.of(context).unfocus(); // 포커스 해제 및 키보드 내리기
    }, child: Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      final isScrollable = constraints.maxHeight < 600;
      final screenWidth = MediaQuery.of(context).size.width; // 화면 너비
      final isTablet = screenWidth >= 768; // 아이패드 여부 판단

      final content = Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/backgroud_icon.png'),
              fit: BoxFit.cover, // 이미지를 화면에 맞게 채우되 비율 유지
            ),
          ),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 33 * pixel),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Image.asset(
                          'assets/icons/logo_icon.png',
                          width: 200 * pixel,
                          height: 152.78 * pixel,
                          fit: BoxFit.contain,
                        ),
                      ],
                    )),
                    SizedBox(
                      height: 20 * pixel,
                    ),
                    LoginTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),
                    SizedBox(height: 10 * pixel),
                    LoginTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 10 * pixel,
                    ),
                    LoginButton(
                      text: _isLoading ? "" : "Sign In",
                      onTap: _isLoading ? null : signUserIn,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : null,
                    ),
                    SizedBox(
                      height: 29 * pixel,
                    ),
                  ])));

      // 600보다 작으면 스크롤 적용

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
