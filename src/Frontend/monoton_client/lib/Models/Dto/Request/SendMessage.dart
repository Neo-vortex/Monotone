import 'package:monoton_client/Models/Enum/MessageType.dart';
import 'package:json_annotation/json_annotation.dart';
part 'SendMessage.g.dart';

@JsonSerializable()
class SendMessage {
  @JsonKey(name: 'Content')
  List<int> content = []; // Dart uses List<int> for byte arrays
  @JsonKey(name: 'TargetChatId')
  late String targetChatId;
  @JsonKey(name: 'MessageType')
  late MessageType messageType ; // You'll need to define the MessageType enum
  @JsonKey(name: 'ResourceAddress')
  late String resourceAddress ;
  @JsonKey(name: 'IsReplay')
  late bool isReplay;
  @JsonKey(name: 'Metadata')
  late String metadata ;
  SendMessage();
  factory SendMessage.fromJson(Map<String, dynamic> json) => _$SendMessageFromJson(json);
  Map<String, dynamic> toJson() => _$SendMessageToJson(this);
}

