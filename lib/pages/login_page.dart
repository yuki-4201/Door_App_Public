import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login/utils/constants.dart';
import 'package:login/pages/register_page.dart';
import 'package:login/pages/home_page.dart';
import 'package:login/pages/hide_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => const LoginPage());
  }

  @override
  LoginPageState createState() => LoginPageState();
}

const storage = FlutterSecureStorage();

class LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLoginInfo();
  }

  Future<void> _loadLoginInfo() async {
    final email = await storage.read(key: 'email');
    final password = await storage.read(key: 'password');
    if (email != null && password != null) {
      _emailController.text = email;
      _passwordController.text = password;
    }
  }
  
  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await supabase.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await storage.write(key: 'email', value: _emailController.text);
      await storage.write(key: 'password', value: _passwordController.text);
      DateTime now = DateTime.now();
      int thisyear = now.year;
      int month = now.month;

      if(month <= 3){
        thisyear -= 1;
      }

      int secondyear = thisyear  - 1;
      int thirdyear = thisyear - 2;
      final email = _emailController.text;
      final regex = RegExp(r'(\d{4})@kenryo\.ed\.jp$');
      final match = regex.firstMatch(email);
      
      if(match != null){
        if (email.endsWith('${thisyear}@kenryo.ed.jp') || email.endsWith('${secondyear}@kenryo.ed.jp') || email.endsWith('${thirdyear}@kenryo.ed.jp')) {
          Navigator.of(context)
            .pushAndRemoveUntil(HomePage.route(), (route) => false);
        }else{  
          context.showErrorSnackBar(message: "卒業生または存在しないアカウントは使用できません。");
        }
      }else if(_emailController.text.endsWith("@kenryo.ed.jp")){
        Navigator.of(context)
          .pushAndRemoveUntil(HidePage.route(), (route) => false);
      }else{
        context.showErrorSnackBar(message: "kenryo.ed.jpのメールアドレスを入力してください。");
      }
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (_) {
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),

      body: ListView(
        padding: formPadding,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'メールアドレス'),
            keyboardType: TextInputType.emailAddress,
          ),
          formSpacer,

          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'パスワード'),
            obscureText: true,
          ),
          formSpacer,

          ElevatedButton.icon(
            onPressed: _isLoading ? null : _signIn,
            label: const Text('ログイン'),
            icon: const Icon(Icons.login),
          ),
          formSpacer,

          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(RegisterPage.route());
            },
            label: const Text('登録'),
            icon: const Icon(Icons.how_to_reg),
          )
        ],
      ),
    );
  }
}
