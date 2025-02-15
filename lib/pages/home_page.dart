import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:login/pages/authentication_page.dart';
import 'package:login/pages/login_page.dart';
import 'package:login/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const HomePage(),
    );
  }

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final myUserId = supabase.auth.currentUser!.email;
  String door = "Select the operation.";
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [
            Icon(Icons.sensor_door),
            Text("KERYO STEAM LAB.")
        ]),
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
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
              title: const Text('KenyroHP'),
              onTap: (){
                final url = Uri.parse('https://kenryo.ed.jp');
                launchUrl(url);
              },
            ),

            ListTile(
              title: const Text('Kenyro Students HP'),
              onTap: (){
                final url = Uri.parse('https://student.kenryo.ed.jp');
                launchUrl(url);
              },
            ),

            ListTile(
              title: const Text('KenryoArchive(iOS)'),
              onTap: (){
                final url = Uri.parse('https://apps.apple.com/jp/app/%E7%B8%A3%E9%99%B5%E6%8E%A2%E7%A9%B6%E3%82%A2%E3%83%BC%E3%82%AB%E3%82%A4%E3%83%96/id6738385612');
                launchUrl(url);
              },
            ),

            ListTile(
              title: const Text('KenryoArchive(Google Drive)'),
              onTap: (){
                final url = Uri.parse('https://drive.google.com/drive/folders/0AG2mAiSF-9WuUk9PVA');
                launchUrl(url);
              },
            ),

            ListTile(
              title: const Text('Logout'),
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
          const Text("Student page",
            style: TextStyle(
              fontSize: 35,
              color: Colors.blue
            ),
          ),

          TextButton.icon(
            onPressed: ()async{
              final channelB = supabase.channel('admin');
              channelB.subscribe((status, error) {
              if (status != RealtimeSubscribeStatus.subscribed) {
                return;
              }

              channelB.sendBroadcastMessage(
                event: 'RequestForLocking',
                payload: {'payload': 424242, 'user':myUserId, 'group':'student'},
              );
              });
              door = 'Door is Locked.';
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
            onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              AuthenticationPage.route(data: myUserId.toString()), // データを渡す
              (route) => false,
              );
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
                door,
                style: const TextStyle(fontSize: 36,),
              )
            ),
          ),

          Container(
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            child: const Text("Made By Hinata Misawa, Kotaro Otsuka in 2024 ©")
          ),
        ],
      ),


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
