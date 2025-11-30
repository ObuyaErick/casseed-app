import 'package:casseed/ui/core/circular_progress_indicator_builder.dart';
import 'package:casseed/ui/core/pin_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PhoneVerificationScreen extends HookConsumerWidget {
  final String phoneNumber;

  const PhoneVerificationScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVerifying = useState(false);
    final errorMessage = useState<String?>(null);
    final successMessage = useState<String?>(null);
    final isResending = useState(false);

    // PIN input controllers (6 digits for phone)
    final pin1Controller = useTextEditingController();
    final pin2Controller = useTextEditingController();
    final pin3Controller = useTextEditingController();
    final pin4Controller = useTextEditingController();
    final pin5Controller = useTextEditingController();
    final pin6Controller = useTextEditingController();

    // Focus nodes
    final pin1Focus = useFocusNode();
    final pin2Focus = useFocusNode();
    final pin3Focus = useFocusNode();
    final pin4Focus = useFocusNode();
    final pin5Focus = useFocusNode();
    final pin6Focus = useFocusNode();

    void verifyPhone() async {
      errorMessage.value = null;
      successMessage.value = null;

      final pin =
          pin1Controller.text +
          pin2Controller.text +
          pin3Controller.text +
          pin4Controller.text +
          pin5Controller.text +
          pin6Controller.text;

      if (pin.length != 6) {
        errorMessage.value = 'Please enter the complete 6-digit code';
        return;
      }

      isVerifying.value = true;

      try {
        // TODO: Replace with actual API call
        // await ref.read(authProvider).verifyPhone(phoneNumber, pin);

        await Future.delayed(const Duration(seconds: 2));

        successMessage.value = 'Phone number verified successfully!';

        // Navigate to next screen
        Future.delayed(const Duration(seconds: 2), () {
          context.go('/dashboard');
        });
      } catch (e) {
        errorMessage.value = 'Invalid or expired code. Please try again.';
      } finally {
        isVerifying.value = false;
      }
    }

    void resendCode() async {
      errorMessage.value = null;
      successMessage.value = null;
      isResending.value = true;

      try {
        // TODO: Replace with actual API call
        // await ref.read(authProvider).resendPhoneVerification(phoneNumber);

        await Future.delayed(const Duration(seconds: 1));

        successMessage.value = 'Verification code sent via SMS';
      } catch (e) {
        errorMessage.value = 'Failed to resend code. Please try again.';
      } finally {
        isResending.value = false;
      }
    }

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
                      Icons.phone_android,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Verify Your Phone',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  Text(
                    'Enter the 6-digit code sent to',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phoneNumber,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // PIN input fields (6 digits)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PinField(
                        width: 32,
                        verticalPadding: 10,
                        controller: pin1Controller,
                        focusNode: pin1Focus,
                        nextFocus: pin2Focus,
                        onChanged: (value) {
                          if (value.isNotEmpty) pin2Focus.requestFocus();
                        },
                      ),
                      const SizedBox(width: 8),
                      PinField(
                        width: 32,
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
                      const SizedBox(width: 8),
                      PinField(
                        width: 32,
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
                      const SizedBox(width: 8),
                      PinField(
                        width: 32,
                        verticalPadding: 10,
                        controller: pin4Controller,
                        focusNode: pin4Focus,
                        previousFocus: pin3Focus,
                        nextFocus: pin5Focus,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            pin5Focus.requestFocus();
                          } else {
                            pin3Focus.requestFocus();
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      PinField(
                        width: 32,
                        verticalPadding: 10,
                        controller: pin5Controller,
                        focusNode: pin5Focus,
                        previousFocus: pin4Focus,
                        nextFocus: pin6Focus,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            pin6Focus.requestFocus();
                          } else {
                            pin4Focus.requestFocus();
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      PinField(
                        width: 32,
                        verticalPadding: 10,
                        controller: pin6Controller,
                        focusNode: pin6Focus,
                        previousFocus: pin5Focus,
                        onChanged: (value) {
                          if (value.isEmpty) pin5Focus.requestFocus();
                        },
                        onSubmit: verifyPhone,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Messages
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
                        ).colorScheme.primaryContainer.withOpacity(0.3),
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
                      onPressed: isVerifying.value ? null : verifyPhone,
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
                          : const Text('Verify Phone'),
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
                        onPressed: isResending.value ? null : resendCode,
                        child: isResending.value
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.primary,
                                  ),
                                ),
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
