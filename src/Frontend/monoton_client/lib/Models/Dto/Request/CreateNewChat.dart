
import 'package:json_annotation/json_annotation.dart';

part 'CreateNewChat.g.dart';


@JsonSerializable()
class CreateNewChatCommand{

  @JsonKey(name: 'OtherParticipents')
  List<String> otherParticipents = [];


  @JsonKey(name: 'GroupName')
  String? groupName;


  CreateNewChatCommand();
  factory CreateNewChatCommand.fromJson(Map<String, dynamic> json) => _$CreateNewChatCommandFromJson(json);
  Map<String, dynamic> toJson() => _$CreateNewChatCommandToJson(this);
}