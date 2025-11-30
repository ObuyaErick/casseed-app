import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_dto.freezed.dart';
part 'reset_password_dto.g.dart';

@Freezed(toJson: true, fromJson: false)
sealed class ResetPasswordDto with _$ResetPasswordDto {
  const factory ResetPasswordDto({
    required String token,
    required String newPassword,
  }) = _ResetPasswordDto;
}
