import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@Freezed()
sealed class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? phone,
    required String firstName,
    required String lastName,
    required String roleId,
    required String organizationId,
    required bool isActive,
    DateTime? emailVerifiedAt,
    DateTime? phoneVerifiedAt,
    DateTime? lastLoginAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
