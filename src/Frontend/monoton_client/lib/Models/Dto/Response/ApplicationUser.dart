import 'package:json_annotation/json_annotation.dart';

part 'ApplicationUser.g.dart';


@JsonSerializable()

class ApplicationUser{

  @JsonKey(name: 'id')
  late String id;

  @JsonKey(name: 'userName')
  late String userName;

  @JsonKey(name: 'profilePicture')
  List<int>? profilePicture ; // Dart uses List<int> f




  ApplicationUser();
  factory ApplicationUser.fromJson(Map<String, dynamic> json) => _$ApplicationUserFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationUserToJson(this);
}