import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_dto.freezed.dart';
part 'forgot_password_dto.g.dart';

@Freezed(toJson: true, fromJson: false)
sealed class ForgotPasswordDto with _$ForgotPasswordDto {
  const factory ForgotPasswordDto({required String email}) = _ForgotPasswordDto;
}
