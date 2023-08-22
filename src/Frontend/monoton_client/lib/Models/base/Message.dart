import 'package:json_annotation/json_annotation.dart';
import 'package:monoton_client/Models/Dto/Response/ApplicationUser.dart';
import 'package:monoton_client/Models/base/Chat.dart';

part 'Message.g.dart';



@JsonSerializable()
class Message {
  @JsonKey(name: 'id')
  late String id;

  @JsonKey(name: 'content')
  late List<int> content;

  @JsonKey(name: 'sender')
  late ApplicationUser sender;

  @JsonKey(name: 'targetChat')
  late Chat targetChat;

  @JsonKey(name: 'createdAt', toJson: _dateTimeToJson, fromJson: _dateTimeFromJson)
  late DateTime createdAt;

  @JsonKey(name: 'messageType')
  late MessageType messageType;

  @JsonKey(name: 'resourceAddress')
  late String resourceAddress;

  @JsonKey(name: 'messageResourceType')
  late MessageResourceType messageResourceType;

  @JsonKey(name: 'isReplay')
  late bool isReplay;

  @JsonKey(name: 'metadata')
  late String metadata;

  @JsonKey(name: 'seenBy')
  late List<ApplicationUser> seenBy;

  Message();

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  static DateTime _dateTimeFromJson(String json) => DateTime.parse(json);

  static String _dateTimeToJson(DateTime dateTime) => dateTime.toIso8601String();
}

enum MessageType {
  @JsonValue('TEXT')
  TEXT,
  @JsonValue('IMAGEM')
  IMAGE,
  @JsonValue('VIDEO')
  VIDEO,
  @JsonValue('FILE')
  FILE,
  @JsonValue('VOICE')
  VOICE,
  @JsonValue('DELETED')
  DELETED,
  @JsonValue('NULL')
  NULL,
}

enum MessageResourceType {
  @JsonValue('INTERNAL')
  INTERNAL,
  @JsonValue('EXTERNAL')
  EXTERNAL,
}