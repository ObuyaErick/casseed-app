import 'package:casseed/models/auth/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_context.freezed.dart';
part 'auth_context.g.dart';

@Freezed()
sealed class AuthContext with _$AuthContext {
  const factory AuthContext({
    required String accessToken,
    required String refreshToken,
    required User user,
  }) = _AuthContext;

  factory AuthContext.fromJson(Map<String, dynamic> json) =>
      _$AuthContextFromJson(json);
}
