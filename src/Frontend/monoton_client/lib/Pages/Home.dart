import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:monoton_client/Models/Dto/Request/SendMessage.dart';
import 'package:monoton_client/Models/Enum/MessageType.dart';
import 'package:monoton_client/Services/SignalRService.dart';
import 'package:monoton_client/Utilities/Utilities.dart';

import '../Services/RestService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String title = "Monotone (Connecting...)";
  bool connectedForTheFirstTime = false;
  @override
  void initState()  {
    super.initState();
    scheduleInitServices();

  }


  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: Scaffold(
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton:  ExpandableFab(

          children: [
            FloatingActionButton.small(
               backgroundColor: Colors.blue,
              heroTag: null,
              child: const Icon(Icons.person),
              onPressed: () async {
                 var message =  new SendMessage();
                  message.content = Utilities.stringToByteArray("hello world");
                  message.isReplay = false;
                  message.messageType = MessageType.TEXT;
                  message.metadata = "";
                  message.resourceAddress = "";
                  message.targetChatId = "123456";
                  var answ =   await SignalRService.hubConnection.invoke("SendMessage", args:  <Object> [ json.encode(message) ] );
                  log(answ as String);
                  },
            ),
            FloatingActionButton.small(
              backgroundColor: Colors.blue,
              heroTag: null,
              child: const Icon(Icons.group),
              onPressed: () {},
            ),
          ],
        ),
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                EasyLoading.showSuccess("ok");
                // do something
              },
            )
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Text("Chats")
            ],
          ),
        ),
      ),
    );
  }




  Timer scheduleinformOnline() =>
      Timer.periodic(const Duration(milliseconds: 5000), (timer) {
        try {
          SignalRService.informOnline();
        }catch (e){
        }
      });

  Timer scheduleInitServices() =>
      Timer.periodic(const Duration(milliseconds: 2000), (timer) async {
        try {
         await initServices();
        }catch (e){
        }
      });


  Future initServices() async {
    if (connectedForTheFirstTime){
      return;
    }
    var restResult =  await RestService.init();
    if (!restResult){
      return;
    }
    var signalResult = await SignalRService.init();

    if (!signalResult){
      return;
    }
    connectedForTheFirstTime = true;
    SignalRService.hubConnection.onclose(({error}) {
      SignalRService.ready  = false;
      setState(() {
        title = "Monotone (Disconnected)";
      }); });
    SignalRService.hubConnection.onreconnecting(({error}) { setState(() {
      title = "Monotone (Reconnecting...)";
    }); });
    SignalRService.hubConnection.onreconnected(({connectionId}) {
      SignalRService.ready  = true;
      setState(() {
        title = "Monotone";
      });
    });
    scheduleinformOnline();
    setState(() {
      title = "Monotone";
    });
  }

}
