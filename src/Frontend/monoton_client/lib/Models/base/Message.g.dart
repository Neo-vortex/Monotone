// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message()
  ..id = json['id'] as String
  ..content = (json['content'] as List<dynamic>).map((e) => e as int).toList()
  ..sender = ApplicationUser.fromJson(json['sender'] as Map<String, dynamic>)
  ..targetChat = Chat.fromJson(json['targetChat'] as Map<String, dynamic>)
  ..createdAt = Message._dateTimeFromJson(json['createdAt'] as String)
  ..messageType = $enumDecode(_$MessageTypeEnumMap, json['messageType'])
  ..resourceAddress = json['resourceAddress'] as String
  ..messageResourceType =
      $enumDecode(_$MessageResourceTypeEnumMap, json['messageResourceType'])
  ..isReplay = json['isReplay'] as bool
  ..metadata = json['metadata'] as String
  ..seenBy = (json['seenBy'] as List<dynamic>)
      .map((e) => ApplicationUser.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'sender': instance.sender,
      'targetChat': instance.targetChat,
      'createdAt': Message._dateTimeToJson(instance.createdAt),
      'messageType': _$MessageTypeEnumMap[instance.messageType]!,
      'resourceAddress': instance.resourceAddress,
      'messageResourceType':
          _$MessageResourceTypeEnumMap[instance.messageResourceType]!,
      'isReplay': instance.isReplay,
      'metadata': instance.metadata,
      'seenBy': instance.seenBy,
    };

const _$MessageTypeEnumMap = {
  MessageType.TEXT: 'TEXT',
  MessageType.IMAGE: 'IMAGEM',
  MessageType.VIDEO: 'VIDEO',
  MessageType.FILE: 'FILE',
  MessageType.VOICE: 'VOICE',
  MessageType.DELETED: 'DELETED',
  MessageType.NULL: 'NULL',
};

const _$MessageResourceTypeEnumMap = {
  MessageResourceType.INTERNAL: 'INTERNAL',
  MessageResourceType.EXTERNAL: 'EXTERNAL',
};
