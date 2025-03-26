import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../auth/component/login_button.dart';
import '../auth/component/login_text_field.dart';
import '../auth/component/show_error_message.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  bool _isLoading = false; // 로딩 상태를 추적하는 변수

  // sign user up method
  Future signUserUp() async {
    // 입력 유효성 검사 추가
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmpasswordController.text.isEmpty) {
      ShowErrorMessage(context: context, message: 'Please fill in all fields.')
          .show();
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}")
        .hasMatch(emailController.text)) {
      ShowErrorMessage(
              context: context, message: 'Please enter a valid email address.')
          .show();
      return;
    }

    if (passwordController.text.length < 6) {
      ShowErrorMessage(
              context: context,
              message: 'Password must be at least 6 characters.')
          .show();
      return;
    }

    setState(() {
      _isLoading = true; // 로딩 상태 관리를 위한 상태 변수 설정
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //add user detial
      //addUserDetails(emailController.text.trim());
      context.go('/');
      // 회원 가입 성공 후 EntryScreen으로 이동
    } on FirebaseAuthException catch (e) {
      // 이곳에서 다양한 FirebaseAuthException 코드를 처리합니다.
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'The email address is already in use by another account.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled.';
          break;
        case 'weak-password':
          message = 'The password is too weak.';
          break;
        default:
          message = 'An unexpected error occurred. Please try again later.';
      }
      ShowErrorMessage(context: context, message: message).show();
    } finally {
      if (mounted) {
        // 위젯이 여전히 마운트되어 있는지 확인
        setState(() {
          _isLoading = false; // 로딩 상태 관리를 위한 상태 변수 설정
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                const Icon(
                  Icons.gesture,
                  size: 100,
                  color: Colors.green,
                ),

                const SizedBox(height: 50),

                // Let's create an account for you
                Text(
                  '캡슐톤에 로그인해,다양한 정보를 만나보세요!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // email textfield
                LoginTextField(
                  controller: emailController,
                  hintText: '이메일',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                LoginTextField(
                  controller: passwordController,
                  hintText: '비밀번호',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // confirm password textfield
                LoginTextField(
                  controller: confirmpasswordController,
                  hintText: '비밀번호 확인',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // sign in button
                LoginButton(
                  text: _isLoading ? "" : "회원가입", // 로딩 중이면 텍스트를 숨깁니다.
                  onTap: _isLoading ? null : signUserUp, // 로딩 중이면 버튼을 비활성화합니다.
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : null, // 로딩 중이면 로딩 인디케이터를 표시합니다.
                ),

                const SizedBox(height: 100),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '이미 로그인 정보가 있나요?',
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
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
