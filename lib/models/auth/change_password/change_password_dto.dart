import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_dto.freezed.dart';
part 'change_password_dto.g.dart';

@Freezed(toJson: true, fromJson: false)
sealed class ChangePasswordDto with _$ChangePasswordDto {
  const factory ChangePasswordDto({
    required String currentPassword,
    required String newPassword,
  }) = _ChangePasswordDto;
}
