import 'dart:convert';

import 'package:flutter/material.dart';

class ChatData {
  final String title;
  final String description;
  final int number;

  ChatData({
    required this.title,
    required this.description,
    required this.number,
  });
}

class ChatItem extends StatelessWidget {
  final ChatData chatData;
  final Function(ChatData) onDelete;
  final Function(ChatData) onArchive;

  ChatItem({
    required this.chatData,
    required this.onDelete,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(chatData.title),
      direction: DismissDirection.horizontal,
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart) {
          _handleDeleteAction(context);
        } else if (direction == DismissDirection.startToEnd) {
          _handleArchiveAction(context);
        }
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        child: Icon(Icons.archive, color: Colors.white),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Ink.image(
          image:  MemoryImage(base64Decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z/C/HgAGgwJ/lK3Q6wAAAABJRU5ErkJggg==')),
          child: InkWell(
            onTap: () {
              // Handle the tap on the whole card
            },
            borderRadius: BorderRadius.circular(16.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              title: Text(chatData.title),
              subtitle: Text(chatData.description),
              trailing: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                width: 30,
                height: 30,
                alignment: Alignment.center,
                child: Text(
                  chatData.number.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDeleteAction(BuildContext context) {
    onDelete(chatData); // Notify the parent widget about the delete action
  }

  void _handleArchiveAction(BuildContext context) {
    onArchive(chatData); // Notify the parent widget about the archive action
  }
}