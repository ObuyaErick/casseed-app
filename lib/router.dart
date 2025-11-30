import 'package:casseed/ui/screens/auth/change_password_screen.dart';
import 'package:casseed/ui/screens/auth/email_verification_screen.dart';
import 'package:casseed/ui/screens/auth/forgot_password_screen.dart';
import 'package:casseed/ui/screens/auth/login_screen.dart';
import 'package:casseed/ui/screens/auth/phone_verification_screen.dart';
import 'package:casseed/ui/screens/auth/register_screen.dart';
import 'package:casseed/ui/screens/auth/reset_password_screen.dart';
import 'package:casseed/ui/screens/welcome/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'landing',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const LandingScreen()),
      ),

      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const LoginScreen()),
      ),

      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const RegisterScreen()),
      ),

      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
        ),
      ),

      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        pageBuilder: (context, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          return MaterialPage(
            key: state.pageKey,
            child: ResetPasswordScreen(token: token),
          );
        },
      ),

      GoRoute(
        path: '/change-password',
        name: 'change-password',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ChangePasswordScreen(),
        ),
      ),
      GoRoute(
        path: '/verify-email',
        name: 'verify-email',
        pageBuilder: (context, state) {
          final token = state.uri.queryParameters['token'];
          final email = state.uri.queryParameters['email'] ?? '';
          return MaterialPage(
            key: state.pageKey,
            child: EmailVerificationScreen(token: token, email: email),
          );
        },
      ),

      // Phone verification
      GoRoute(
        path: '/verify-phone',
        name: 'verify-phone',
        pageBuilder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return MaterialPage(
            key: state.pageKey,
            child: PhoneVerificationScreen(phoneNumber: phone),
          );
        },
      ),

      // GoRoute(
      //   path: '/dashboard',
      //   name: 'dashboard',
      //   pageBuilder: (context, state) => MaterialPage(
      //     key: state.pageKey,
      //     child: const DashboardScreen(),
      //   ),
      // ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
