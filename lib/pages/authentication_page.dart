// ignore: unused_import
// ignore_for_file: unused_field

// ignore: unused_import
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login/pages/home_page.dart';
// ignore: unused_import
import 'package:login/utils/constants.dart';
// ignore: unused_import
import 'package:supabase_flutter/supabase_flutter.dart';

/// 他のユーザーとチャットができるページ
///
/// `ListView`内にチャットが表示され、下の`TextField`から他のユーザーへチャットを送信できる。
class AuthenticationPage extends StatefulWidget {
  // ignore: use_super_parameters
  const AuthenticationPage({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const AuthenticationPage(),
    );
  }
  @override
  State<AuthenticationPage> createState() => AuthenticationPageState();
}
class AuthenticationPageState extends State<AuthenticationPage> {
  // Create a text controller and use it to retrieve the current value 
  // of the TextField.
  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed. 
    myController.dispose(); super.dispose(); 
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [
            Icon(Icons.sensor_door),
            Text("Kenryo Lab application")
        ]),
      ),
      body: Column(
        mainAxisAlignment : MainAxisAlignment.center,
        children: <Widget>[
        // ignore: prefer_const_constructors
        Text(
          "ドアに表示されている認証コードを入力してください",
          // ignore: prefer_const_constructors
          style: TextStyle(fontSize: 17),
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: myController,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Enter number.',
          ),
        ),
        TextButton.icon(
          onPressed: ()async{
            await supabase
              .from('action')
              .insert({'text': "Unlock" ,"number": myController.text});
            // ignore: use_build_context_synchronously
            Navigator.of(context)
            .pushAndRemoveUntil(HomePage.route(), (route) => false);
            setState((){});
          }, 
          icon: const Icon(
            Icons.done,
            color:Colors.blue,
            size : 50
          ),
          label: const Flexible(child: Text('done',
            style: TextStyle(
            fontSize: 30,)),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          child: const Text("made by Kenryo Physics and Chemistry Club")
        ),
      ],),
    );
  }
}
