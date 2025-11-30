// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$RegisterDtoToJson(_RegisterDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'organizationName': instance.organizationName,
      'organizationType': _$OrganizationTypeEnumMap[instance.organizationType]!,
    };

const _$OrganizationTypeEnumMap = {
  OrganizationType.farmer: 'farmer',
  OrganizationType.supplier: 'supplier',
  OrganizationType.processor: 'processor',
  OrganizationType.distributor: 'distributor',
  OrganizationType.retailer: 'retailer',
  OrganizationType.other: 'other',
};
