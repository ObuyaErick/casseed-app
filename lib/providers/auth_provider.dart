import 'dart:async';

import 'package:casseed/api/api_client.dart';
import 'package:casseed/models/auth/auth_state/auth_context.dart';
import 'package:casseed/models/auth/auth_state/auth_state.dart';
import 'package:casseed/models/auth/login/login_dto.dart';
import 'package:casseed/models/auth/register/register_dto.dart';
import 'package:casseed/models/auth/user/user.dart';
import 'package:casseed/providers/api_client_provider.dart';
import 'package:casseed/services/token_storage.dart';
import 'package:casseed/ui/core/alerts/app_notification.dart';
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

  Future<void> _initializeAuth() async {
    state = state.copyWith(isLoading: true);

    try {
      final accessToken = await _storage.getAccessToken();
      final refreshToken = await _storage.getRefreshToken();

      if (accessToken != null && refreshToken != null) {
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
              error: "Failed to retrieve your login session!",
            );
          }

          _scheduleTokenRefresh();
        } catch (e) {
          await _refreshAccessToken();
        }
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
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
      } else {
        AuthState(
          currentContext: null,
          isLoading: false,
          error: "Failed to login please try again",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register(RegisterDto registerDto) async {
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
      } else {
        AuthState(
          currentContext: null,
          isLoading: false,
          error: "Failed to register please try again.",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    state = AuthState();
    // try {
    //   if (state.accessToken != null) {
    //     await _repository.logout(state.accessToken!);
    //   }
    // } catch (e) {
    //   // Continue with logout even if API call fails
    //   debugPrint('Logout error: $e');
    // } finally {
    //   _tokenRefreshTimer?.cancel();
    //   await _storage.clearTokens();
    //   state = state.clear();
    // }
  }

  // Refresh access token
  Future<void> _refreshAccessToken() async {
    final refreshToken =
        state.currentContext?.refreshToken ?? await _storage.getRefreshToken();

    if (refreshToken == null) {
      await logout();
      return;
    }

    try {
      // final response = await _repository.refreshToken(refreshToken);

      // final newAccessToken = response['accessToken'] as String;
      // final newRefreshToken = response['refreshToken'] as String;

      // await _storage.saveTokens(newAccessToken, newRefreshToken);

      // state = state.copyWith(
      //   accessToken: newAccessToken,
      //   refreshToken: newRefreshToken,
      // );

      _scheduleTokenRefresh();
    } catch (e) {
      await logout();
    }
  }

  void _scheduleTokenRefresh() {
    // _tokenRefreshTimer?.cancel();
    // _tokenRefreshTimer = Timer(
    //   const Duration(minutes: 45), // Refresh every 45 minutes for 1-hour tokens
    //   _refreshAccessToken,
    // );
  }

  // Get current access token
  String? get accessToken => state.currentContext?.accessToken;

  // Get current user
  User? get currentUser => state.currentContext?.user;

  @override
  void dispose() {
    // _tokenRefreshTimer?.cancel();
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
