// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ApplicationUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationUser _$ApplicationUserFromJson(Map<String, dynamic> json) =>
    ApplicationUser()
      ..id = json['id'] as String
      ..userName = json['userName'] as String
      ..profilePicture = (json['profilePicture'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList();

Map<String, dynamic> _$ApplicationUserToJson(ApplicationUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'profilePicture': instance.profilePicture,
    };
