import 'package:flutter/material.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:monoton_client/Models/Widgets/ChatItem.dart';

class Conversation extends StatefulWidget {
  const Conversation( {Key? key, required this.chatData}) : super(key: key);

  final ChatData chatData;

  @override
  State<Conversation> createState() => _ConversationState(chatData.chat.id);
}

class _ConversationState extends State<Conversation> {
  String userId ;
  final List<types.Message> _messages = [];
  _ConversationState(this.userId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chat(

        onAttachmentPressed: _handleImageSelection,
        theme: const DarkChatTheme(
          primaryColor: Colors.blue,
        ),
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: types.User(id: userId),
      ),
    );;
  }
  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: types.User(id: "asdasd"),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: "asdfsdsdasd",
      text: message.text,
    );

    _addMessage(textMessage);
  }



  void _handleImageSelection() {

  }
}
