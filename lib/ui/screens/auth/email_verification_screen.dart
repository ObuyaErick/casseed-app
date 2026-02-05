import 'package:casseed/ui/core/pin_field.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:casseed/ui/core/circular_progress_indicator_builder.dart';

class EmailVerificationScreen extends HookConsumerWidget {
  final String? token;
  final String email;

  const EmailVerificationScreen({super.key, this.token, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVerifying = useState(false);
    final errorMessage = useState<String?>(null);
    final successMessage = useState<String?>(null);
    final isResending = useState(false);

    final pin1Controller = useTextEditingController();
    final pin2Controller = useTextEditingController();
    final pin3Controller = useTextEditingController();
    final pin4Controller = useTextEditingController();

    final pin1Focus = useFocusNode();
    final pin2Focus = useFocusNode();
    final pin3Focus = useFocusNode();
    final pin4Focus = useFocusNode();

    // Auto-verify on web if token is provided
    useEffect(() {
      if (kIsWeb && token != null && token!.isNotEmpty) {
        Future.microtask(
          () => verifyWithToken(
            token!,
            isVerifying,
            errorMessage,
            successMessage,
            context,
          ),
        );
      }
      return null;
    }, [token]);

    void verifyWithPin() async {
      errorMessage.value = null;
      successMessage.value = null;

      final pin =
          pin1Controller.text +
          pin2Controller.text +
          pin3Controller.text +
          pin4Controller.text;

      if (pin.length != 4) {
        errorMessage.value = 'Please enter the complete 4-digit code';
        return;
      }

      isVerifying.value = true;

      try {
        // TODO: Replace with actual API call
        // final verifyEmailDto = VerifyEmailDto(token: pin);
        // await ref.read(authProvider).verifyEmail(verifyEmailDto);

        await Future.delayed(const Duration(seconds: 2));

        successMessage.value = 'Email verified successfully!';

        // Navigate to dashboard after success
        Future.delayed(const Duration(seconds: 2), () {
          context.push('/dashboard');
        });
      } catch (e) {
        errorMessage.value = 'Invalid or expired code. Please try again.';
      } finally {
        isVerifying.value = false;
      }
    }

    void resendVerificationCode() async {
      errorMessage.value = null;
      successMessage.value = null;
      isResending.value = true;

      try {
        // TODO: Replace with actual API call
        // final resendDto = ResendVerificationDto(email: email);
        // await ref.read(authProvider).resendVerification(resendDto);

        await Future.delayed(const Duration(seconds: 1));

        successMessage.value = 'Verification code sent to your email';
      } catch (e) {
        errorMessage.value = 'Failed to resend code. Please try again.';
      } finally {
        isResending.value = false;
      }
    }

    // Web view - Show loading/success/error for token verification
    if (kIsWeb) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: successMessage.value != null
                          ? Theme.of(context).colorScheme.primaryContainer
                          : errorMessage.value != null
                          ? Theme.of(context).colorScheme.errorContainer
                          : Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      successMessage.value != null
                          ? Icons.check_circle_outline
                          : errorMessage.value != null
                          ? Icons.error_outline
                          : Icons.email_outlined,
                      size: 40,
                      color: successMessage.value != null
                          ? Theme.of(context).colorScheme.primary
                          : errorMessage.value != null
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    isVerifying.value
                        ? 'Verifying Email...'
                        : successMessage.value != null
                        ? 'Email Verified!'
                        : errorMessage.value != null
                        ? 'Verification Failed'
                        : 'Verify Your Email',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  if (isVerifying.value)
                    buildCircularProgressIndicator(context)
                  else if (successMessage.value != null)
                    Column(
                      children: [
                        Text(
                          successMessage.value!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Redirecting to dashboard...',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    )
                  else if (errorMessage.value != null)
                    Column(
                      children: [
                        Text(
                          errorMessage.value!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: () => context.push('/login'),
                          child: const Text('Go to Login'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Mobile view - PIN entry
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.mark_email_unread_outlined,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Verify Your Email',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  Text(
                    'Enter the 4-digit code sent to',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // PIN input fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PinField(
                        width: 36,
                        verticalPadding: 10,
                        controller: pin1Controller,
                        focusNode: pin1Focus,
                        nextFocus: pin2Focus,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            pin2Focus.requestFocus();
                          }
                        },
                      ),
                      const SizedBox(width: 12),
                      PinField(
                        width: 36,
                        verticalPadding: 10,
                        controller: pin2Controller,
                        focusNode: pin2Focus,
                        previousFocus: pin1Focus,
                        nextFocus: pin3Focus,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            pin3Focus.requestFocus();
                          } else {
                            pin1Focus.requestFocus();
                          }
                        },
                      ),
                      const SizedBox(width: 12),
                      PinField(
                        width: 36,
                        verticalPadding: 10,
                        controller: pin3Controller,
                        focusNode: pin3Focus,
                        previousFocus: pin2Focus,
                        nextFocus: pin4Focus,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            pin4Focus.requestFocus();
                          } else {
                            pin2Focus.requestFocus();
                          }
                        },
                      ),
                      const SizedBox(width: 12),
                      PinField(
                        width: 36,
                        verticalPadding: 10,
                        controller: pin4Controller,
                        focusNode: pin4Focus,
                        previousFocus: pin3Focus,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            pin3Focus.requestFocus();
                          }
                        },
                        onSubmit: verifyWithPin,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Error/Success messages
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

                  if (successMessage.value != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: Row(
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

                  if (errorMessage.value != null ||
                      successMessage.value != null)
                    const SizedBox(height: 16),

                  // Verify button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isVerifying.value ? null : verifyWithPin,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: isVerifying.value
                          ? buildCircularProgressIndicator(
                              context,
                              color: Theme.of(context).colorScheme.onSurface,
                            )
                          : const Text('Verify Email'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Resend code
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive the code? ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: isResending.value
                            ? null
                            : resendVerificationCode,
                        child: isResending.value
                            ? buildCircularProgressIndicator(
                                context,
                                color: Theme.of(context).colorScheme.onSurface,
                              )
                            : const Text(
                                'Resend',
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
    );
  }
}

void verifyWithToken(
  String token,
  ValueNotifier<bool> isVerifying,
  ValueNotifier<String?> errorMessage,
  ValueNotifier<String?> successMessage,
  BuildContext context,
) async {
  isVerifying.value = true;
  errorMessage.value = null;

  try {
    // TODO: Replace with actual API call
    // final verifyEmailDto = VerifyEmailDto(token: token);
    // await ref.read(authProvider).verifyEmail(verifyEmailDto);

    await Future.delayed(const Duration(seconds: 2));

    successMessage.value = 'Email verified successfully!';
  } catch (e) {
    errorMessage.value = 'Invalid or expired verification link.';
  } finally {
    isVerifying.value = false;
  }
}
