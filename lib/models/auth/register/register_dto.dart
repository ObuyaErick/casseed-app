import 'package:casseed/models/auth/organization_type.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_dto.freezed.dart';
part 'register_dto.g.dart';

@Freezed(toJson: true, fromJson: false)
sealed class RegisterDto with _$RegisterDto {
  const factory RegisterDto({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    required String organizationName,
    required OrganizationType organizationType,
  }) = _RegisterDto;

  factory RegisterDto.fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();
}
