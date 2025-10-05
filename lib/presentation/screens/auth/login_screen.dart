import 'package:flutter/material.dart';
import '../../components/layout/auth_layout.dart';
import '../../components/forms/input_fields.dart';
import '../../components/buttons/square_button.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/constants/app_colors.dart';

/// ログイン画面
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    // if (!_formKey.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: 実際のログイン処理を実装
      await Future.delayed(const Duration(seconds: 2)); // シミュレーション

      if (mounted) {
        // ログイン成功時の処理
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ログインしました'),
            backgroundColor: Colors.green,
          ),
        );

        // ホーム画面への遷移
        Navigator.pushReplacementNamed(context, RouteNames.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ログインに失敗しました: $e'),
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

  void _onForgotPasswordTap() {
    // TODO: パスワード忘れた画面への遷移
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('パスワードリセット機能は未実装です')));
  }

  void _onRegisterTap() {
    Navigator.pushNamed(context, RouteNames.register);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      // bottomText: 'アカウント作成はこちら',
      onBottomTextTap: _onRegisterTap,
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // メールアドレス入力
              EmailInputField(
                controller: _emailController,
                labelColor: textOnPrimary,
                label: 'メールアドレス',
                hintText: 'example@gmail.com',
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
              PasswordInputField(
                controller: _passwordController,
                labelColor: textOnPrimary,
                label: 'パスワード',
                hintText: 'パスワードを入力',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'パスワードを入力してください';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // ログインボタン
              SquareButton(
                text: 'ログイン',
                onPressed: _isLoading ? null : _onLoginPressed,
                isLoading: _isLoading,
              ),

              const SizedBox(height: 16),

              // パスワードを忘れた
              Center(
                child: GestureDetector(
                  onTap: _onForgotPasswordTap,
                  child: const Text(
                    'パスワードを忘れた',
                    style: TextStyle(
                      color: textOnPrimary,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
