// ignore: unused_import
// ignore_for_file: unused_field

// ignore: unused_import
import 'dart:async';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:login/main.dart' as main;
import 'package:login/pages/home_page.dart';
// ignore: unused_import
import 'package:login/utils/constants.dart';
// ignore: unused_import
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:login/pages/hide_page.dart';



class PassPage extends StatefulWidget {
  // ignore: use_super_parameters
  const PassPage({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const PassPage(),
    );
  }
  @override
  State<PassPage> createState() => PassPageState();
}
class PassPageState extends State<PassPage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final pass_number = TextEditingController();
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
          "Please enter the passward",
          // ignore: prefer_const_constructors
          style: TextStyle(fontSize: 17),
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: pass_number,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Enter number.',
          ),
        ),
        TextButton.icon(
          onPressed: ()async{
            if (pass_number.text != "1234") {
              Navigator.of(context)
              .pushAndRemoveUntil(HomePage.route(), (route) => false);
              setState((){});
            } else {
              Navigator.of(context)
              .pushAndRemoveUntil(HidePage.route(), (route) => false);
              setState((){});
            }
          },
          icon: const Icon(
            Icons.done,
            color:Colors.blue,
            size : 50
          ),
          label: const Text('done',
            style: TextStyle(
            fontSize: 30,)),
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
