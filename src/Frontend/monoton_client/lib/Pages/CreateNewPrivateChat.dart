import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monoton_client/Models/Dto/Request/CreateNewChat.dart';
import 'package:monoton_client/Services/RestService.dart';

import '../Services/StorageService.dart';
import 'Home.dart';

class CreateNewPrivateChat extends StatefulWidget {
  const CreateNewPrivateChat({Key? key}) : super(key: key);

  @override
  State<CreateNewPrivateChat> createState() => _CreateNewPrivateChatState();
}

class _CreateNewPrivateChatState extends State<CreateNewPrivateChat> {
  List<String> usernames = []; // Simulated list of usernames
  List<String> filteredUsernames = [];

  @override
  void initState() {
    super.initState();
    usernames = [];
    filteredUsernames = usernames;
  }

  void _searchUsername(String query) async {
    context.loaderOverlay.show();
    filteredUsernames =  await RestService.SearchUsername(query);
    var selfName = await StorageService.storage.read(key: "name");
    filteredUsernames = filteredUsernames.where((element)  => element !=  selfName ).toList();
    context.loaderOverlay.hide();
    setState(() {
    });
  }

  Future<void> _showConfirmationDialog(String selectedUsername) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start Chatting'),
          content: Text('Do you want to start chatting with $selectedUsername?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Start Chat'),
              onPressed: ()  {
                Navigator.of(context).pop();
                createChat(selectedUsername);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Navigate back when the back button is pressed
              },
            ),
            title: Text('Create New Private Chat'),
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: _searchUsername,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredUsernames.length,
                  itemBuilder: (context, index) {
                    final username = filteredUsernames[index];
                    return ListTile(
                      title: Text(username),
                      onTap: () {
                        _showConfirmationDialog(username); // Show confirmation dialog before action
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    ) ;
  }

  void createChat(String selectedUsername) async  {
     context.loaderOverlay.show();
      var createNewChat = CreateNewChatCommand();
      createNewChat.groupName = null;
      var selfId = await StorageService.storage.read(key: "id");
      var user = await RestService.GetUserByUserName(selectedUsername);
      createNewChat.otherParticipents = [selfId! ,user!.id ];
      var newChatId = RestService.CreateNewChat(createNewChat);
      context.loaderOverlay.hide();
  }
}