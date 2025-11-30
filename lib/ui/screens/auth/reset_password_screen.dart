import 'package:casseed/ui/core/circular_progress_indicator_builder.dart';
import 'package:casseed/ui/core/labelled_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResetPasswordScreen extends HookConsumerWidget {
  final String token;

  const ResetPasswordScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Form key for validation
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final newPasswordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    final obscureNewPassword = useState(true);
    final obscureConfirmPassword = useState(true);
    final errorMessage = useState<String?>(null);
    final successMessage = useState<String?>(null);
    final isLoading = useState(false);

    // New password validator
    String? validateNewPassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Password is too short';
      }

      if (value.length < 8) {
        return 'Password is too short';
      }

      final hasUppercase = value.contains(RegExp(r'[A-Z]'));
      final hasLowercase = value.contains(RegExp(r'[a-z]'));
      final hasNumber = value.contains(RegExp(r'[0-9]'));
      final hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      if (!hasUppercase || !hasLowercase || !hasNumber || !hasSpecialChar) {
        return 'Password must contain uppercase, lowercase, number and special character';
      }

      return null;
    }

    // Confirm password validator
    String? validateConfirmPassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password';
      }

      if (value != newPasswordController.text) {
        return 'Passwords do not match';
      }

      return null;
    }

    void handleResetPassword() async {
      // Clear previous messages
      errorMessage.value = null;
      successMessage.value = null;

      // Validate form
      if (!formKey.currentState!.validate()) {
        return;
      }

      isLoading.value = true;

      try {
        final newPassword = newPasswordController.text;

        // TODO: Replace with actual API call
        // final resetPasswordDto = ResetPasswordDto(
        //   token: token,
        //   newPassword: newPassword,
        // );
        // await ref.read(authProvider).resetPassword(resetPasswordDto);

        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        // Show success message
        successMessage.value =
            'Your password has been reset successfully. You can now log in with your new password.';

        // TODO: Navigate to login after delay
        // Future.delayed(const Duration(seconds: 2), () {
        //   Navigator.of(context).pushReplacementNamed('/login');
        // });
      } catch (e) {
        errorMessage.value =
            'Failed to reset password. The link may be invalid or expired. Please request a new reset link.';
      } finally {
        isLoading.value = false;
      }
    }

    // Password strength indicator
    Widget buildPasswordStrengthIndicator(String password) {
      final hasMinLength = password.length >= 8;
      final hasUppercase = password.contains(RegExp(r'[A-Z]'));
      final hasLowercase = password.contains(RegExp(r'[a-z]'));
      final hasNumber = password.contains(RegExp(r'[0-9]'));
      final hasSpecialChar = password.contains(
        RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
      );

      final meetsRequirements = [
        hasMinLength,
        hasUppercase,
        hasLowercase,
        hasNumber,
        hasSpecialChar,
      ];
      final metCount = meetsRequirements.where((met) => met).length;

      Color getStrengthColor() {
        if (metCount <= 2) return Theme.of(context).colorScheme.error;
        if (metCount == 3 || metCount == 4) {
          return Colors.orange;
        }
        return Theme.of(context).colorScheme.primary;
      }

      String getStrengthText() {
        if (metCount <= 2) return 'Weak';
        if (metCount == 3 || metCount == 4) return 'Medium';
        return 'Strong';
      }

      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: metCount / 5,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      getStrengthColor(),
                    ),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  getStrengthText(),
                  style: TextStyle(
                    fontSize: 12,
                    color: getStrengthColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _RequirementItem(
              text: 'At least 8 characters',
              isMet: hasMinLength,
            ),
            _RequirementItem(text: 'Uppercase letter', isMet: hasUppercase),
            _RequirementItem(text: 'Lowercase letter', isMet: hasLowercase),
            _RequirementItem(text: 'Number', isMet: hasNumber),
            _RequirementItem(text: 'Special character', isMet: hasSpecialChar),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icon
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.lock_reset,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      'Reset Password',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Text(
                      'Create a strong password for your account.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // New password field
                    LabelledField(
                      labelText: 'New Password',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: newPasswordController,
                            obscureText: obscureNewPassword.value,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Enter new password',
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureNewPassword.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                ),
                                onPressed: () {
                                  obscureNewPassword.value =
                                      !obscureNewPassword.value;
                                },
                              ),
                            ),
                            validator: validateNewPassword,
                            onChanged: (value) {
                              if (errorMessage.value != null) {
                                errorMessage.value = null;
                              }
                              if (successMessage.value != null) {
                                successMessage.value = null;
                              }
                              // Trigger rebuild to update strength indicator
                              formKey.currentState?.validate();
                            },
                          ),
                          buildPasswordStrengthIndicator(
                            newPasswordController.text,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Confirm password field
                    LabelledField(
                      labelText: 'Confirm New Password',
                      child: TextFormField(
                        controller: confirmPasswordController,
                        obscureText: obscureConfirmPassword.value,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Re-enter new password',
                          prefixIcon: const Icon(Icons.lock_outline, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureConfirmPassword.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20,
                            ),
                            onPressed: () {
                              obscureConfirmPassword.value =
                                  !obscureConfirmPassword.value;
                            },
                          ),
                        ),
                        validator: validateConfirmPassword,
                        onChanged: (_) {
                          if (errorMessage.value != null) {
                            errorMessage.value = null;
                          }
                          if (successMessage.value != null) {
                            successMessage.value = null;
                          }
                        },
                        onFieldSubmitted: (_) => handleResetPassword(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Success message
                    if (successMessage.value != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                successMessage.value!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Error message
                    if (errorMessage.value != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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

                    if (errorMessage.value != null ||
                        successMessage.value != null)
                      const SizedBox(height: 16),

                    // Reset password button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: isLoading.value ? null : handleResetPassword,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 2,
                        ),
                        child: isLoading.value
                            ? buildCircularProgressIndicator(
                                context,
                                color: Theme.of(context).colorScheme.onSurface,
                              )
                            : const Text('Reset Password'),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Back to login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Remember your password? ',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go("/login");
                          },
                          child: const Text(
                            'Log In',
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
    );
  }
}

// Helper widget for password requirement items
class _RequirementItem extends StatelessWidget {
  final String text;
  final bool isMet;

  const _RequirementItem({required this.text, required this.isMet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isMet
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
