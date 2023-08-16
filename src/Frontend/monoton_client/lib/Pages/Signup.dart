import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monoton_client/Pages/Home.dart';
import 'package:monoton_client/Pages/Login.dart';
import 'package:monoton_client/Services/RestService.dart';
import 'package:monoton_client/Services/SignalRService.dart';
class SingupScreen extends StatefulWidget {
  const SingupScreen({Key? key}) : super(key: key);

  @override
  State<SingupScreen> createState() => _SingupState();
}

class _SingupState extends State<SingupScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
                        var result =  await RestService.signup(usernameController.text.trim().toLowerCase(), passwordController.text);
                        if (! result){
                         throw Exception();
                        }
                        await RestService.login(usernameController.text.trim().toLowerCase(), passwordController.text);
                        await SignalRService.init();



                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  const HomeScreen()));

                      }catch (e){
                        context.loaderOverlay.hide();
                        Fluttertoast.showToast(
                            msg: "Invalid Signup",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                    }, child: const Text("Signup")),
                    TextButton(onPressed: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
                    }, child: Text("already have an account?, Login!"))

                  ],
                ),
              ),
            )  ,

          ),
        )
    );
  }
}
