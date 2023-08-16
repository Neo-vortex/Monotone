// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SendMessage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessage _$SendMessageFromJson(Map<String, dynamic> json) => SendMessage()
  ..content = (json['Content'] as List<dynamic>).map((e) => e as int).toList()
  ..targetChatId = json['TargetChatId'] as String
  ..messageType = $enumDecode(_$MessageTypeEnumMap, json['MessageType'])
  ..resourceAddress = json['ResourceAddress'] as String
  ..isReplay = json['IsReplay'] as bool
  ..metadata = json['Metadata'] as String;

Map<String, dynamic> _$SendMessageToJson(SendMessage instance) =>
    <String, dynamic>{
      'Content': instance.content,
      'TargetChatId': instance.targetChatId,
      'MessageType': _$MessageTypeEnumMap[instance.messageType]!,
      'ResourceAddress': instance.resourceAddress,
      'IsReplay': instance.isReplay,
      'Metadata': instance.metadata,
    };

const _$MessageTypeEnumMap = {
  MessageType.TEXT: 0,
  MessageType.IMAGE: 1,
  MessageType.VIDEO: 2,
  MessageType.FILE: 3,
  MessageType.VOICE: 4,
  MessageType.DELETED: 5,
  MessageType.NULL: 6,
};
