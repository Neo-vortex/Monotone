import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monoton_client/Pages/Home.dart';
import 'package:monoton_client/Pages/Signup.dart';
import 'package:monoton_client/Services/RestService.dart';
import 'package:monoton_client/Services/SignalRService.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScrenState();
}

class _LoginScrenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();



  void _showMessageBox(BuildContext context, String message, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
      home : LoaderOverlay(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:  Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.message_outlined,
                    color: Colors.blueAccent,
                    size: 50.0,
                  ),
                  Text("Monotone"),
                  SizedBox(height: 50,),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Username',
                    ),
                    controller:  usernameController,
                  ),
                  SizedBox(height: 30,),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                    ),
                    controller:  passwordController,
                  ),
                  SizedBox(height: 30,),
                  ElevatedButton(onPressed: () async {
                    try{

                      context.loaderOverlay.show();
                      await RestService.init();
                      await RestService.login(usernameController.text.trim().toLowerCase(), passwordController.text);
                      await SignalRService.init();

                      context.loaderOverlay.hide();

                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  const HomeScreen()));

                    }catch (e){
                      context.loaderOverlay.hide();
                      _showMessageBox(context, "Invalid login", "Login" );
                    }
                  }, child: const Text("Login")),
                  TextButton(onPressed: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SingupScreen()));
                  }, child: Text("Don't have account?, Signup!"))

                ],
              ),
            ),
          )  ,

        ),
      )
    );

  }
}
