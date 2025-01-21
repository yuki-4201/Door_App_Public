// ignore: unused_import
// ignore_for_file: unused_field, sort_child_properties_last, prefer_const_constructors

// ignore: unused_import
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login/pages/login_page.dart';
// ignore: unused_import
import 'package:login/utils/constants.dart';
// ignore: unused_import
import 'package:supabase_flutter/supabase_flutter.dart';
// ignore: unused_import
import 'package:login/pages/authentication_page.dart';

/// 他のユーザーとチャットができるページ
///
/// `ListView`内にチャットが表示され、下の`TextField`から他のユーザーへチャットを送信できる。
class HomePage extends StatefulWidget {
  // ignore: use_super_parameters
  const HomePage({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const HomePage(),
    );
  }
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // ignore: non_constant_identifier_names
  String Door = "Select the operation.";
  int _counter = 0;
  // ignore: unused_element
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [
            Icon(Icons.sensor_door),
            Text("KENRYO STEAM LAB.")
        ]),
      ),
      drawer: Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          child: Center(
            child: Text(
              'Menu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        ListTile(
          title: Text('Logout'),
          onTap: () => {Navigator.of(context)
          .pushAndRemoveUntil(LoginPage.route(), (route) => false)
          },
        ),
      ],
    ),
  ),
      body: Column(
        mainAxisAlignment : MainAxisAlignment.center,
        children: <Widget>[
        Text("Student page",
          style: const TextStyle(
            fontSize: 35,
            color: Colors.blue
          ),
        TextButton.icon(
          onPressed: ()async{
            await supabase
              .from('action')
              .insert({'text': 'Lock','number':424242});
            final channelB = supabase.channel('admin');
            channelB.subscribe((status, error) {
            if (status != RealtimeSubscribeStatus.subscribed) {
              return;
            }
            // Send a message once the client is subscribed
            channelB.sendBroadcastMessage(
              event: 'RequestForLocking',
              payload: {'payload': 424242, 'user':'student'},
            );
            });
            Door = 'Door is Locked.';
            setState((){});
          },
          icon: const Icon(
            Icons.lock,
            color:Colors.pink,
            size : 50
          ),
          label: const Flexible(child: Text('lock',
            style: TextStyle(
            fontSize: 30,)),
          ),
        ),
        TextButton.icon(
          onPressed: ()async{Navigator.of(context)
            .pushAndRemoveUntil(AuthenticationPage.route(), (route) => false);
            Door = 'Door is Unlocked.';
            await supabase
              .from('action')
              .insert({'text': 'Unlock Request','number':565656});
          },
          icon: const Icon(
            Icons.lock_open,
            color:Colors.blue,
            size : 50
          ),
          label: const Flexible(child: Text('unlock',
            style: TextStyle(
            fontSize: 30,)),
          ),
        ),
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 4),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(10),
          child: Center(
            child: Text(
              Door,
              style: const TextStyle(fontSize: 36,),
            )),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          child: const Text("Made By Hinata Misawa, Kotaro Otsuka in 2024 ©")
        ),
      ],),
      floatingActionButton:
        FloatingActionButton(
        onPressed: () => {Navigator.of(context)
          .pushAndRemoveUntil(LoginPage.route(), (route) => false)
        },
        child: const Icon(Icons.logout)
        ),
    );
  }
}
