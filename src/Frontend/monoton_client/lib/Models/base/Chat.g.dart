// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat()
  ..id = json['id'] as String
  ..participants = (json['participants'] as List<dynamic>)
      .map((e) => ApplicationUser.fromJson(e as Map<String, dynamic>))
      .toList()
  ..creator = ApplicationUser.fromJson(json['creator'] as Map<String, dynamic>)
  ..createdAt = DateTime.parse(json['createdAt'] as String)
  ..isGroup = json['isGroup'] as bool
  ..groupName = json['groupName'] as String;

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'id': instance.id,
      'participants': instance.participants,
      'creator': instance.creator,
      'createdAt': instance.createdAt.toIso8601String(),
      'isGroup': instance.isGroup,
      'groupName': instance.groupName,
    };
