import 'package:json_annotation/json_annotation.dart';
import 'package:monoton_client/Models/Dto/Response/ApplicationUser.dart';

part 'Chat.g.dart';


@JsonSerializable()
class Chat {
  @JsonKey(name: 'id')
  late String id;

  @JsonKey(name: 'participants')
  late List<ApplicationUser> participants;

  @JsonKey(name: 'creator')
  late ApplicationUser creator;

  @JsonKey(name: 'createdAt')
  late DateTime createdAt;

  @JsonKey(name: 'isGroup')
  late bool isGroup;

  @JsonKey(name: 'groupName')
  late String groupName;

  Chat();

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}