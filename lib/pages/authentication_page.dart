// ignore: unused_import
// ignore_for_file: unused_field, avoid_print, non_constant_identifier_names

// ignore: unused_import
import 'dart:async';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:login/main.dart';
import 'package:login/pages/home_page.dart';
// ignore: unused_import
import 'package:login/utils/constants.dart';
// ignore: unused_import
import 'package:supabase_flutter/supabase_flutter.dart';



class AuthenticationPage extends StatefulWidget {
  final String data;

  const AuthenticationPage({Key? key, required this.data}) : super(key: key);

  static Route<void> route({required String data}) {
    return MaterialPageRoute(
      builder: (context) => AuthenticationPage(data: data),
    );
  }

  @override
  State<AuthenticationPage> createState() => AuthenticationPageState();
}
class AuthenticationPageState extends State<AuthenticationPage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final auth_number = TextEditingController();
  late String myUserId;

  @override
  void initState() {
    super.initState();
    myUserId = widget.data; // 受け取ったデータを myUserId に代入
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    auth_number.dispose(); super.dispose();
  }
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [
            Icon(Icons.sensor_door),
            Text("Kenryo Lab Application")
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
          controller: auth_number,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Enter number.',
          ),
        ),
        TextButton.icon(
          onPressed: ()async{
            final message = auth_number.text;
            final channelB = supabase.channel('admin');
            channelB.subscribe((status, error) {
            // Wait for successful connection
            debugPrint('debug: _SendMessage');
            if (status != RealtimeSubscribeStatus.subscribed) {
              return;
            }
            // Send a message once the client is subscribed
            channelB.sendBroadcastMessage(
              event: 'RequestForUnlocking',
              payload: {'payload': message, 'user':myUserId, 'group':'student'},
            );
            });
            print("45");
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
