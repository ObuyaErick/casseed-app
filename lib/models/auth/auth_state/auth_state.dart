import 'package:casseed/models/auth/auth_state/auth_context.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
sealed class AuthState with _$AuthState {
  factory AuthState({
    AuthContext? currentContext,
    @Default(false) bool isLoading,
    String? error,
  }) = _AuthState;

  AuthState._();

  bool get isAuthenticated => currentContext != null;
}
