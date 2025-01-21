// ignore_for_file: unused_import, prefer_interpolation_to_compose_strings, use_build_context_synchronously, duplicate_ignore

//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:login/pages/register_page.dart';
import 'package:login/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:login/pages/home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login/pages/hide_page.dart';
import 'package:login/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  // ignore: use_super_parameters
  const LoginPage({Key? key}) : super(key: key);

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
      // Save login info
      await storage.write(key: 'email', value: _emailController.text);
      await storage.write(key: 'password', value: _passwordController.text);
      DateTime now = DateTime.now();
      // 今年の西暦を取得
      int thisYear = now.year;
      int month = now.month;
      int secondYear = thisYear  - 1;
      int thirdYear = thisYear - 2;
      int lasYear = thisYear - 3;
      RegExp regex = RegExp(r"^[^@]+(\d{" + lastYear.length + "})@kenryo\.ed\.jp$");
      regex = regex.replaceFirstMapped(RegExp(r"\d{" + lastYear.length + "}"), (Match match) {
        return r"[1-9]\d{0," + (lastYear.length - 1) + "}|\d{" + (lastYear.length - 1) + "}";
      });
      // Navigate to home page
      // ignore: use_build_context_synchronously
      if(_emailController.text.endsWith(thisYear.toString() +"@kenryo.ed.jp") || _emailController.text.endsWith(secondYear.toString() +"@kenryo.ed.jp") || _emailController.text.endsWith(thirdYear.toString() +"@kenryo.ed.jp") || _emailController.text.endsWith(secondYear.toString() +"@kenryo.ed.jp")){
        Navigator.of(context)
          .pushAndRemoveUntil(HomePage.route(), (route) => false);
      }else if(_emailController.text.endsWith(lastYear.toString() + "@kenryo.ed.jp")){
        context.showErrorSnackBar(message: "卒業生のアカウントは使用できません。");
      }else if(regex(_emailController.text)){
        Navigator.of(context)
          .pushAndRemoveUntil(HidePage.route(), (route) => false);
      }else{
        context.showErrorSnackBar(message: "kenryo.ed.jpのメールアドレスを入力してください。");
      }
    } on AuthException catch (error) {
      // ignore: use_build_context_synchronously
      context.showErrorSnackBar(message: error.message);
    } catch (_) {
      // ignore: use_build_context_synchronously
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
          ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(RegisterPage.route());
              },
              label: const Text('登録'),
              icon: const Icon(Icons.login),
          )
        ],
      ),
    );
  }
}
