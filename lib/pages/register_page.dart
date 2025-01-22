import 'package:flutter/material.dart';
import 'package:login/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:login/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  // ignore: use_super_parameters
  const RegisterPage({Key? key}) : super(key: key);

  static Route<void> route({bool isRegistering = false}) {
    return MaterialPageRoute(
      builder: (context) => const RegisterPage(),
    );
  }

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  Future<void> _signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    final email = _emailController.text;
    final password = _passwordController.text;
    final username = _usernameController.text;
    try {
      await supabase.auth.signUp(
          email: email, password: password, data: {'username': username});
      //     .pushAndRemoveUntil(ChatPage.route(), (route) => false);
    } on AuthException catch (error) {
      // ignore: use_build_context_synchronously
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      // ignore: use_build_context_synchronously
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登録'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: formPadding,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                label: Text('メールアドレス(縣陵メールのみ)'),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return '必須';
                }else if (!val.endsWith('@kenryo.ed.jp')){
                  return 'kenryo.ed.jpのメールアドレスを入力してください';
                }return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            formSpacer,
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                label: Text('パスワード(英数混合8文字以上)'),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return '必須';
                }
                if (val.length < 8) {
                  return '8文字以上';
                }
                return null;
              },
            ),
            formSpacer,
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _signUp,
              label: const Text('登録して確認メールを送信'),
              icon: const Icon(Icons.how_to_reg),
            ),
            formSpacer,
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(LoginPage.route());
              },
              label: const Text('すでにアカウントをお持ちの方はこちら'),
              icon: const Icon(Icons.login),
            )
          ],
        ),
      ),
    );
  }
}
