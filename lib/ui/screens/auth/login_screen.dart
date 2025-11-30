import 'package:casseed/models/auth/login/login_dto.dart';
import 'package:casseed/providers/auth_provider.dart';
import 'package:casseed/ui/core/circular_progress_indicator_builder.dart';
import 'package:casseed/ui/core/labelled_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);
    final errorMessage = useState<String?>(null);
    final isLoading = useState(false);

    String? validateEmail(String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'a valid email is required';
      }

      final email = value.trim().toLowerCase();

      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );

      if (!emailRegex.hasMatch(email)) {
        return 'a valid email is required';
      }

      return null;
    }

    String? validatePassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'password is missing';
      }

      return null;
    }

    void handleLogin() async {
      errorMessage.value = null;

      if (!formKey.currentState!.validate()) {
        return;
      }

      isLoading.value = true;

      final response = await ref
          .read(authProvider.notifier)
          .login(
            LoginDto(
              email: emailController.text.trim(),
              password: passwordController.text,
            ),
          );

      errorMessage.value = response.message;

      isLoading.value = false;
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.energy_savings_leaf,
                            size: 40,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Welcome text
                      Text(
                        'Welcome Back',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 32),

                      // Email field
                      LabelledField(
                        labelText: 'Email Address',
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: 'Enter your email',
                            prefixIcon: Icon(Icons.email_outlined, size: 20),
                          ),
                          validator: validateEmail,
                          onChanged: (_) {
                            if (errorMessage.value != null) {
                              errorMessage.value = null;
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Password field
                      LabelledField(
                        labelText: 'Password',
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: obscurePassword.value,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              size: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                              ),
                              onPressed: () {
                                obscurePassword.value = !obscurePassword.value;
                              },
                            ),
                          ),
                          validator: validatePassword,
                          onChanged: (_) {
                            if (errorMessage.value != null) {
                              errorMessage.value = null;
                            }
                          },
                          onFieldSubmitted: (_) => handleLogin(),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Forgot password link
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.go("/forgot-password");
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Error message
                      if (errorMessage.value != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Theme.of(context).colorScheme.error,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  errorMessage.value!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (errorMessage.value != null)
                        const SizedBox(height: 16),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: isLoading.value ? null : handleLogin,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 2,
                          ),
                          child: isLoading.value
                              ? buildCircularProgressIndicator(
                                  context,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                )
                              : const Text('Log In'),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Sign up link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.go("/register");
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
