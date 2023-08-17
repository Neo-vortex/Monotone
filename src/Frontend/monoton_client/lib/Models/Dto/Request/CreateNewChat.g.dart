// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CreateNewChat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateNewChatCommand _$CreateNewChatCommandFromJson(
        Map<String, dynamic> json) =>
    CreateNewChatCommand()
      ..otherParticipents = (json['OtherParticipents'] as List<dynamic>)
          .map((e) => e as String)
          .toList()
      ..groupName = json['GroupName'] as String?;

Map<String, dynamic> _$CreateNewChatCommandToJson(
        CreateNewChatCommand instance) =>
    <String, dynamic>{
      'OtherParticipents': instance.otherParticipents,
      'GroupName': instance.groupName,
    };
