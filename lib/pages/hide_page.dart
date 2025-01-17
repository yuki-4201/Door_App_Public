// ignore: unused_import
// ignore_for_file: unused_field, sort_child_properties_last, prefer_const_constructors, unused_import, duplicate_ignore

// ignore: unused_import
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login/pages/home_page.dart';
import 'package:login/pages/login_page.dart';
// ignore: unused_import
import 'package:login/utils/constants.dart';
// ignore: unused_import
import 'package:supabase_flutter/supabase_flutter.dart';
// ignore: unused_import
import 'package:login/pages/authentication_page.dart';
import 'package:url_launcher/url_launcher.dart';

/// 他のユーザーとチャットができるページ
///
/// `ListView`内にチャットが表示され、下の`TextField`から他のユーザーへチャットを送信できる。
class HidePage extends StatefulWidget {
  // ignore: use_super_parameters
  const HidePage({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const HidePage(),
    );
  }
  @override
  State<HidePage> createState() => HidePageState();
}

class AlertDialogSample extends StatelessWidget {
  const AlertDialogSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('解錠してもいいですか？'),
      content: Text('学校外で解錠操作を行なっていませんか？'),
      actions: <Widget>[
        ElevatedButton(
          child: Text('解錠しない'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('解錠する'),
          onPressed: () async {
            final channelB = supabase.channel('admin');
            channelB.subscribe((status, error) {
            if (status != RealtimeSubscribeStatus.subscribed) {
              return;
            }
            // Send a message once the client is subscribed
            channelB.sendBroadcastMessage(
              event: 'RequestForUnlocking',
              payload: {'payload': 9999, 'user':'teacher'},
            );
            Navigator.of(context).pop();
            });
          },
        )
      ],
    );
  }
}

class HidePageState extends State<HidePage> {
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
            Text("Kenryo Lab Application")
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
          title: Text('TeacherPage'),
          onTap: () => {Navigator.of(context)
            .pushAndRemoveUntil(HidePage.route(), (route) => false)
          },
        ),
        ListTile(
          title: const Text('Log_Search'),
          onTap: (){
            final url = Uri.parse('https://docs.google.com/spreadsheets/d/1ZOGaawYWA1fQg_ULgRasc-IO_01mwRQ4vZedu4WeAA8/edit?gid=1834174406#gid=1834174406');
            launchUrl(url);
          },
        ),
        ListTile(
          title: const Text('KenyroHP'),
          onTap: (){
            final url = Uri.parse('https://kenryo.ed.jp');
            launchUrl(url);
          },
        ),
        ListTile(
          title: const Text('KenryoArchive'),
          onTap: (){
            final url = Uri.parse('https://drive.google.com/drive/folders/0AG2mAiSF-9WuUk9PVA');
            launchUrl(url);
          },
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
        Text("TeacherPage",
          style: const TextStyle(
            fontSize: 35,
            color: Colors.blue
          ),
        ),
        const SizedBox(height: 30),
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
              payload: {'payload': 424242, 'user':'teacher'},
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
          onPressed: ()async{
            await supabase
              .from('action')
              .insert({'text': 'Lock','number':565656});
            showDialog<void>(
            context: context,
            builder: (_) {
              return AlertDialogSample();
            });
            Door = 'Finish Action.';
            setState((){});
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
          child: const Text("made by Kenryo Physics and Chemistry Club")
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