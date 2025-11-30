// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  roleId: json['roleId'] as String,
  organizationId: json['organizationId'] as String,
  isActive: json['isActive'] as bool,
  emailVerifiedAt: json['emailVerifiedAt'] == null
      ? null
      : DateTime.parse(json['emailVerifiedAt'] as String),
  phoneVerifiedAt: json['phoneVerifiedAt'] == null
      ? null
      : DateTime.parse(json['phoneVerifiedAt'] as String),
  lastLoginAt: json['lastLoginAt'] == null
      ? null
      : DateTime.parse(json['lastLoginAt'] as String),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'phone': instance.phone,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'roleId': instance.roleId,
  'organizationId': instance.organizationId,
  'isActive': instance.isActive,
  'emailVerifiedAt': instance.emailVerifiedAt?.toIso8601String(),
  'phoneVerifiedAt': instance.phoneVerifiedAt?.toIso8601String(),
  'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
};
