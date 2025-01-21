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
  Future<void> signInWithEmail() async {
  final AuthResponse res = await supabase.auth.signinwithotp(email: 'valid.email@supabase.io');
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
