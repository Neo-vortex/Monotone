import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:monoton_client/Pages/Login.dart';
import 'package:monoton_client/Services/StorageService.dart';
import 'package:signalr_netcore/signalr_client.dart';

import 'Pages/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monotone',
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
      home: const MyHomePage(title: 'Monotone Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
            () async {
      if (await checkJwtExists()){

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else
      {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  const LoginScreen()));
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home:  const Scaffold(
          body:  Center(
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.message_outlined,
                    color: Colors.blueAccent,
                    size: 50.0,
                  ),
                  Text("Monotone"),
               ],
              )
          )),
    );

  }

Future<bool> checkJwtExists() async{
  var result = await StorageService.storage.read(key: "jwt");
  return result != null;
}

}
