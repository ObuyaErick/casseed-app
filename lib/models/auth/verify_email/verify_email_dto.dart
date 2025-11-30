import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_email_dto.freezed.dart';
part 'verify_email_dto.g.dart';

@Freezed(toJson: true, fromJson: false)
sealed class VerifyEmailDto with _$VerifyEmailDto {
  const factory VerifyEmailDto({required String token}) = _VerifyEmailDto;
}
