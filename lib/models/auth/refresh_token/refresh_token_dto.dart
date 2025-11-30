import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_token_dto.freezed.dart';
part 'refresh_token_dto.g.dart';

@Freezed(toJson: true, fromJson: false)
sealed class RefreshTokenDto with _$RefreshTokenDto {
  const factory RefreshTokenDto({required String refreshToken}) =
      _RefreshTokenDto;
}
