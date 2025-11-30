// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthContext _$AuthContextFromJson(Map<String, dynamic> json) => _AuthContext(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthContextToJson(_AuthContext instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
    };
