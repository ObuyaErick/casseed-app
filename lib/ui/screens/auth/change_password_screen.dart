import 'package:casseed/models/auth/change_password/change_password_dto.dart';
import 'package:casseed/providers/auth_provider.dart';
import 'package:casseed/ui/core/circular_progress_indicator_builder.dart';
import 'package:casseed/ui/core/labelled_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChangePasswordScreen extends HookConsumerWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final currentPasswordController = useTextEditingController();
    final newPasswordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    final obscureCurrentPassword = useState(true);
    final obscureNewPassword = useState(true);
    final obscureConfirmPassword = useState(true);
    final isLoading = useState(false);

    String? validateCurrentPassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'current password is required';
      }

      return null;
    }

    String? validateNewPassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'password is too short (less than 8 characters)';
      }

      if (value.length < 8) {
        return 'password is too short (less than 8 characters)';
      }

      final hasUppercase = value.contains(RegExp(r'[A-Z]'));
      final hasLowercase = value.contains(RegExp(r'[a-z]'));
      final hasNumber = value.contains(RegExp(r'[0-9]'));
      final hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      if (!hasUppercase || !hasLowercase || !hasNumber || !hasSpecialChar) {
        return 'password must contain uppercase, lowercase, number and special character';
      }

      return null;
    }

    String? validateConfirmPassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'please confirm your new password';
      }

      if (value != newPasswordController.text) {
        return 'passwords do not match';
      }

      return null;
    }

    void handleChangePassword() async {
      if (!formKey.currentState!.validate()) {
        return;
      }

      isLoading.value = true;

      final currentPassword = currentPasswordController.text;
      final newPassword = newPasswordController.text;

      final changePasswordDto = ChangePasswordDto(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      await ref.read(authProvider.notifier).changePassword(changePasswordDto);

      // Clear form
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      isLoading.value = false;
    }

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
        title: const Text('Change Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
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
                          Icons.lock_outline,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Description
                    Text(
                      'Create a strong password to keep your account secure.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Current password
                    LabelledField(
                      labelText: 'Current Password',
                      child: TextFormField(
                        controller: currentPasswordController,
                        obscureText: obscureCurrentPassword.value,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Enter current password',
                          prefixIcon: const Icon(Icons.lock_outline, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureCurrentPassword.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20,
                            ),
                            onPressed: () {
                              obscureCurrentPassword.value =
                                  !obscureCurrentPassword.value;
                            },
                          ),
                        ),
                        validator: validateCurrentPassword,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // New password
                    LabelledField(
                      labelText: 'New Password',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
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
                          ),
                          buildPasswordStrengthIndicator(
                            newPasswordController.text,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Confirm password
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

                        onFieldSubmitted: (_) => handleChangePassword(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Change password button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: isLoading.value
                            ? null
                            : handleChangePassword,
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
                            : const Text('Update Password'),
                      ),
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
