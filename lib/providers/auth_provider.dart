import 'dart:async';

import 'package:casseed/api/api_client.dart';
import 'package:casseed/models/auth/auth_state/auth_context.dart';
import 'package:casseed/models/auth/auth_state/auth_state.dart';
import 'package:casseed/models/auth/change_password/change_password_dto.dart';
import 'package:casseed/models/auth/forgot_password/forgot_password_dto.dart';
import 'package:casseed/models/auth/login/login_dto.dart';
import 'package:casseed/models/auth/refresh_token/refresh_token_dto.dart';
import 'package:casseed/models/auth/register/register_dto.dart';
import 'package:casseed/models/auth/reset_password/reset_password_dto.dart';
import 'package:casseed/models/auth/user/user.dart';
import 'package:casseed/providers/api_client_provider.dart';
import 'package:casseed/services/token_storage.dart';
import 'package:casseed/ui/core/alerts/app_notification.dart';
import 'package:casseed/ui/core/alerts/notification_severity.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiClient _apiClient;
  final TokenStorage _storage;
  AuthNotifier({required ApiClient apiClient, required TokenStorage storage})
    : _apiClient = apiClient,
      _storage = storage,
      super(AuthState()) {
    _initializeAuth();
  }

  Timer? _tokenRefreshTimer;

  String? get accessToken => state.currentContext?.accessToken;

  User? get currentUser => state.currentContext?.user;

  Future<void> _initializeAuth() async {
    state = state.copyWith(isLoading: true);

    final accessToken = await _storage.getAccessToken();
    final refreshToken = await _storage.getRefreshToken();

    if (accessToken != null && refreshToken != null) {
      state = state.copyWith(isLoading: false);
      try {
        final response = await _apiClient.get(
          "session",
          scope: ApiScope.auth,
          fromJsonT: (json) =>
              AuthContext.fromJson(json as Map<String, dynamic>),
        );

        if (response.isSuccessful && response.data.isNotEmpty) {
          state = AuthState(
            currentContext: response.data.first,
            isLoading: false,
          );
        } else {
          state = AuthState(
            currentContext: null,
            isLoading: false,
            error: "Failed to retrieve session! Please login again.",
          );
        }

        _scheduleTokenRefresh();
      } catch (e) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<MutationStatus<AuthContext>> login(LoginDto loginDto) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.post(
        "login",
        scope: ApiScope.auth,
        body: loginDto.toJson(),
        fromJsonT: (json) => AuthContext.fromJson(json as Map<String, dynamic>),
      );

      if (response.isSuccessful && response.hasData) {
        final authContext = response.data.first;
        state = AuthState(
          currentContext: authContext,
          isLoading: false,
          error: null,
        );

        await _storage.saveTokens(
          authContext.accessToken,
          authContext.refreshToken,
        );

        _scheduleTokenRefresh();

        return MutationStatus(
          message: "Login successful",
          severity: NotificationSeverity.success,
          resource: authContext,
        );
      } else {
        state = AuthState(
          currentContext: null,
          isLoading: false,
          error: "Login failed! Please try again.",
        );

        return MutationStatus(
          message: "Login failed! Please try again.",
          severity: NotificationSeverity.success,
          resource: null,
        );
      }
    } catch (e) {
      final errorMessage = "Login failed";
      state = state.copyWith(
        currentContext: null,
        isLoading: false,
        error: errorMessage,
      );
      return MutationStatus(
        message: errorMessage,
        severity: NotificationSeverity.error,
      );
    }
  }

  Future<MutationStatus<AuthContext>> register(RegisterDto registerDto) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.post(
        "register",
        scope: ApiScope.auth,
        body: registerDto.toJson(),
        fromJsonT: (json) => AuthContext.fromJson(json as Map<String, dynamic>),
      );

      if (response.isSuccessful && response.hasData) {
        final authContext = response.data.first;
        state = AuthState(
          currentContext: authContext,
          isLoading: false,
          error: null,
        );

        await _storage.saveTokens(
          authContext.accessToken,
          authContext.refreshToken,
        );

        _scheduleTokenRefresh();

        return MutationStatus(
          message: "Registration successful",
          severity: NotificationSeverity.success,
          resource: authContext,
        );
      } else {
        AuthState(
          currentContext: null,
          isLoading: false,
          error: "Registration failed! Please try again.",
        );

        return MutationStatus(
          message: "Registration failed! Please try again",
          severity: NotificationSeverity.success,
          resource: null,
        );
      }
    } catch (e) {
      final errorMessage = "Registration failed";
      state = state.copyWith(
        currentContext: null,
        isLoading: false,
        error: errorMessage,
      );
      return MutationStatus(
        message: errorMessage,
        severity: NotificationSeverity.error,
      );
    }
  }

  Future<MutationStatus<AuthContext>> changePassword(
    ChangePasswordDto changePasswordDto,
  ) async {
    try {
      final response = await _apiClient.post(
        "change-password",
        scope: ApiScope.auth,
        body: changePasswordDto.toJson(),
        fromJsonT: (json) => AuthContext.fromJson(json as Map<String, dynamic>),
      );

      if (response.isSuccessful && response.hasData) {
        final authContext = response.data.first;
        state = AuthState(
          currentContext: authContext,
          isLoading: false,
          error: null,
        );

        await _storage.saveTokens(
          authContext.accessToken,
          authContext.refreshToken,
        );

        _scheduleTokenRefresh();

        return MutationStatus(
          message: "Registration successful",
          severity: NotificationSeverity.success,
          resource: authContext,
        );
      } else {
        AuthState(
          currentContext: null,
          isLoading: false,
          error: "Registration failed! Please try again.",
        );

        return MutationStatus(
          message: "Registration failed! Please try again",
          severity: NotificationSeverity.success,
          resource: null,
        );
      }
    } catch (e) {
      final errorMessage = "Registration failed";
      state = state.copyWith(
        currentContext: null,
        isLoading: false,
        error: errorMessage,
      );
      return MutationStatus(
        message: errorMessage,
        severity: NotificationSeverity.error,
      );
    }
  }

  Future<String?> processForgotPassword(
    ForgotPasswordDto forgotPasswordDto,
  ) async {
    return "Please check your email on instructions to reset your password.";
  }

  Future<String?> resetPassword(ResetPasswordDto resetPasswordDto) async {
    return "Your password has been reset successfully. You can now log in with your new password.";
  }

  Future<void> logout() async {
    state = AuthState();
    await _storage.clearTokens();
  }

  Future<void> _refreshAccessToken() async {
    final refreshToken =
        state.currentContext?.refreshToken ?? await _storage.getRefreshToken();

    if (refreshToken == null) {
      state = AuthState(
        currentContext: null,
        error: "Failed to refresh session! Please login again.",
      );
      return;
    }

    try {
      final response = await _apiClient.post(
        "refresh-token",
        scope: ApiScope.auth,
        body: RefreshTokenDto(refreshToken: refreshToken).toJson(),
        fromJsonT: (json) => AuthContext.fromJson(json as Map<String, dynamic>),
      );

      if (response.isSuccessful && response.hasData) {
        final authContext = response.data.first;
        state = AuthState(
          currentContext: authContext,
          isLoading: false,
          error: null,
        );

        await _storage.saveTokens(
          authContext.accessToken,
          authContext.refreshToken,
        );

        _scheduleTokenRefresh();
      } else {
        AuthState(
          currentContext: null,
          isLoading: false,
          error: "Failed to refresh session! Please login again.",
        );
      }
    } catch (e) {
      final errorMessage = "Failed to refresh session! Please login again.";
      state = state.copyWith(
        currentContext: null,
        isLoading: false,
        error: errorMessage,
      );
    }
  }

  void _scheduleTokenRefresh() {
    _tokenRefreshTimer?.cancel();
    _tokenRefreshTimer = Timer(
      const Duration(minutes: 45),
      _refreshAccessToken,
    );
  }

  @override
  void dispose() {
    _tokenRefreshTimer?.cancel();
    super.dispose();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storage = ref.watch(tokenStorageProvider);
  return AuthNotifier(apiClient: apiClient, storage: storage);
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).currentContext?.user;
});

final accessTokenProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).currentContext?.accessToken;
});
