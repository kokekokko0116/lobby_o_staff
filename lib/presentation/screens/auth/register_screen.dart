import 'package:flutter/material.dart';
import '../../components/layout/auth_layout.dart';
import '../../components/forms/input_fields.dart';
import '../../components/buttons/square_button.dart';

/// アカウント作成画面
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _pinCodeController = TextEditingController();
  bool _isLoading = false;
  final bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onRegisterPressed() async {
    // if (!_formKey.validate()) return;

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('利用規約とプライバシーポリシーに同意してください'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: 実際のアカウント作成処理を実装
      await Future.delayed(const Duration(seconds: 2)); // シミュレーション

      if (mounted) {
        // アカウント作成成功時の処理
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('アカウントを作成しました'),
            backgroundColor: Colors.green,
          ),
        );

        // TODO: ログイン画面または認証画面への遷移
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('アカウント作成に失敗しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onLoginTap() {
    Navigator.pop(context); // ログイン画面に戻る
  }


  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      bottomText: 'すでにアカウントをお持ちですか？',
      onBottomTextTap: _onLoginTap,
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),

              // メールアドレス入力
              EmailInputField(
                controller: _emailController,
                label: 'メールアドレス',
                hintText: 'example@gmail.com',
                labelColor: Colors.white, // 白いラベル
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'メールアドレスを入力してください';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                  if (!emailRegex.hasMatch(value)) {
                    return '正しいメールアドレスを入力してください';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // パスワード入力
              // PasswordInputField(
              //   controller: _passwordController,
              //   label: 'パスワード',
              //   hintText: '8文字以上のパスワード',
              //   helperText: '8文字以上の英数字を含むパスワードを入力してください',
              //   labelColor: Colors.white, // 白いラベル
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'パスワードを入力してください';
              //     }
              //     if (value.length < 8) {
              //       return 'パスワードは8文字以上で入力してください';
              //     }
              //     return null;
              //   },
              // ),
              PinCodeInputField(
                controller: _pinCodeController,
                label: 'ピンコード',
                hintText: 'ピンコードを入力',
                labelColor: Colors.white, // 白いラベル
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ピンコードを入力してください';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // アカウント作成ボタン
              SquareButton(
                text: 'アカウントを作成',
                onPressed: _isLoading ? null : _onRegisterPressed,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
