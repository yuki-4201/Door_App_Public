import 'package:flutter/material.dart';
import 'package:login/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AuthenticationPage extends StatefulWidget {
  final String data;
  const AuthenticationPage({super.key, required this.data});

  static Route<void> route({required String data}) {
    return MaterialPageRoute(
      builder: (context) => AuthenticationPage(data: data),
    );
  }

  @override
  State<AuthenticationPage> createState() => AuthenticationPageState();
}


class AuthenticationPageState extends State<AuthenticationPage> {
  final authNumber = TextEditingController();
  late String myUserId;
  @override

  void initState() {
    super.initState();
    myUserId = widget.data;
  }

  @override
  void dispose() {
    authNumber.dispose(); super.dispose();
  }

  final supabase = Supabase.instance.client;
  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [
          Icon(Icons.sensor_door),
          Text("Kenryo Lab Application")]
        ),
      ),


      body: Column(
        mainAxisAlignment : MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "ドアに表示されている認証コードを入力してください",
            style: TextStyle(fontSize: 17),
          ),


          TextFormField(
            keyboardType: TextInputType.number,
            controller: authNumber,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter number.',
            ),
          ),


          TextButton.icon(
            onPressed: ()async{
              final message = authNumber.text;
              final channelB = supabase.channel('admin');
              channelB.subscribe((status, error) {
              debugPrint('debug: _SendMessage');
              if (status != RealtimeSubscribeStatus.subscribed) {
                return;
              }
              channelB.sendBroadcastMessage(
                event: 'RequestForUnlocking',
                payload: {'payload': message, 'user':myUserId, 'group':'student'},
              );
              });
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
        ],
      ),
    );
  }
}
