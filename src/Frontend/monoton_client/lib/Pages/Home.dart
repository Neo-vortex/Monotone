import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:monoton_client/Models/Dto/Request/SendMessage.dart';
import 'package:monoton_client/Models/Enum/MessageType.dart';
import 'package:monoton_client/Models/Widgets/ChatItem.dart';
import 'package:monoton_client/Pages/Conversation.dart';
import 'package:monoton_client/Pages/CreateNewPrivateChat.dart';
import 'package:monoton_client/Services/SignalRService.dart';
import 'package:monoton_client/Services/StorageService.dart';
import 'package:monoton_client/Utilities/Utilities.dart';
import 'package:monoton_client/main.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../Services/RestService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String title = "Monotone (Connecting...)";
  bool connectedForTheFirstTime = false;
  List<ChatData> chats = [
  ];
  List<ChatData> filteredChats = [];

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  late final Timer _initServiceTimer;
  @override
  void initState()  {
    super.initState();
    filteredChats = chats;
    _initServiceTimer =  scheduleInitServices();
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

        drawer: Drawer(
          child: ListView(
            children: const [
              DrawerHeader(child: Text("Monoton")),
              ListTile(
                title: Text(
                  'Profile',
                ),
                leading: Icon(
                  Icons.person,
                ),
              ),
              ListTile(
                title: Text(
                  'Share',
                ),
                leading: Icon(
                  Icons.share,
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton:  ExpandableFab(

          children: [
            FloatingActionButton.small(
               backgroundColor: Colors.blue,
              heroTag: null,
              child: const Icon(Icons.person),
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const CreateNewPrivateChat()));
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
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () async {
                await StorageService.storage.deleteAll();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  const MyApp()));

                // do something
              },
            )
          ],
        ),
        body:
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:   Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:       Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: filterChats,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(child:    SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: const WaterDropHeader(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child:  ListView.builder(
                  itemCount: filteredChats.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 80,
                      child: ChatItem(chatData: filteredChats[index],
                        onDelete: (ChatData ) {

                      },
                        onArchive: (ChatData ) {

                        },
                        onTap: (String ) async {
                          await  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  Conversation(chatData: filteredChats[index],)));
                          refreshAllChatList(reload: false);

                        },),
                    );
                  },
                ),
              ))
           ,
            ],
          ),
        )


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
    if (connectedForTheFirstTime) {
      return;
    }
    connectedForTheFirstTime = true;
    var restResult = await RestService.init();
    if (!restResult) {
      connectedForTheFirstTime = false;
      return;
    }
    var signalResult = await SignalRService.init();

    if (!signalResult) {
      connectedForTheFirstTime = false;
      return;
    }
    SignalRService.hubConnection.onclose(({error}) {
      SignalRService.ready = false;
      setState(() {
        title = "Monotone (Disconnected)";
      });
    });
    SignalRService.hubConnection.onreconnecting(({error}) {
      setState(() {
        title = "Monotone (Reconnecting...)";
      });
    });
    SignalRService.hubConnection.onreconnected(({connectionId}) {
      SignalRService.ready = true;
      setState(() {
        title = "Monotone";
      });
    });
    scheduleinformOnline();
    setState(() {
      title = "Monotone";
    });
    _initServiceTimer.cancel();
    _refreshController.requestRefresh();
  }

  void filterChats(String query) {
    setState(() {
      filteredChats = chats.where((chat) =>
          chat.title.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _onRefresh() async{
     await refreshAllChatList();
     _refreshController.refreshCompleted();

  }

  void _onLoading() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }



  Future refreshAllChatList({bool reload = true}) async{
    var result  = await RestService.GetMyChats();
    if (result != null){
      if (result.any((element) => element.number > 0) && reload ){
        FlutterRingtonePlayer.playNotification();
      }
    }
    setState(() {
      if (result != null){
        chats = result;
        filteredChats = result;
      }
    });
  }
}
