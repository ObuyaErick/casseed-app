import 'package:freezed_annotation/freezed_annotation.dart';

part 'resend_verification_dto.freezed.dart';
part 'resend_verification_dto.g.dart';

@Freezed(toJson: true, fromJson: false)
sealed class ResendVerificationDto with _$ResendVerificationDto {
  const factory ResendVerificationDto({required String email}) =
      _ResendVerificationDto;
}
