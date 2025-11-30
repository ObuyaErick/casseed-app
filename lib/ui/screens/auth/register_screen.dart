import 'package:casseed/extensions/organization_type_extensions.dart';
import 'package:casseed/models/auth/organization_type.enum.dart';
import 'package:casseed/models/auth/register/register_dto.dart';
import 'package:casseed/providers/auth_provider.dart';
import 'package:casseed/ui/core/circular_progress_indicator_builder.dart';
import 'package:casseed/ui/core/labelled_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey1 = useMemoized(() => GlobalKey<FormState>());
    final formKey2 = useMemoized(() => GlobalKey<FormState>());
    final formKey3 = useMemoized(() => GlobalKey<FormState>());

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final organizationNameController = useTextEditingController();

    final currentStep = useState(0);
    final obscurePassword = useState(true);
    final selectedOrgType = useState<OrganizationType?>(null);
    final errorMessage = useState<String?>(null);
    final isLoading = useState(false);

    String? validateEmail(String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'A valid email address is required';
      }

      final email = value.trim().toLowerCase();
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );

      if (!emailRegex.hasMatch(email)) {
        return 'A valid email address is required';
      }

      return null;
    }

    String? validatePassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Password too short';
      }

      if (value.length < 8) {
        return 'Password too short';
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

    String? validateFirstName(String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'first name invalid or too short';
      }

      if (value.trim().length < 2) {
        return 'first name invalid or too short';
      }

      if (value.trim().length > 100) {
        return 'first name invalid or too long';
      }

      return null;
    }

    String? validateLastName(String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'last name invalid or too short';
      }

      if (value.trim().length < 2) {
        return 'last name invalid or too short';
      }

      if (value.trim().length > 100) {
        return 'last name invalid or too long';
      }

      return null;
    }

    String? validatePhone(String? value) {
      if (value == null || value.trim().isEmpty) {
        return null;
      }

      final phoneRegex = RegExp(r'^\+254[17]\d{8}$');

      if (!phoneRegex.hasMatch(value.trim())) {
        return 'please provide a valid Kenyan phone number';
      }

      return null;
    }

    String? validateOrganizationName(String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'organization name invalid or too short';
      }

      if (value.trim().length < 3) {
        return 'organization name invalid or too short';
      }

      if (value.trim().length > 255) {
        return 'organization name invalid or too long';
      }

      return null;
    }

    String? validateOrganizationType(OrganizationType? value) {
      if (value == null) {
        return 'organization type must be selected';
      }
      return null;
    }

    // Navigation handlers
    void goToNextStep() {
      errorMessage.value = null;

      GlobalKey<FormState>? currentFormKey;
      if (currentStep.value == 0) {
        currentFormKey = formKey1;
      } else if (currentStep.value == 1) {
        currentFormKey = formKey2;
      } else if (currentStep.value == 2) {
        currentFormKey = formKey3;
      }

      if (currentFormKey?.currentState?.validate() ?? false) {
        if (currentStep.value < 2) {
          currentStep.value++;
        }
      }
    }

    void goToPreviousStep() {
      errorMessage.value = null;
      if (currentStep.value > 0) {
        currentStep.value--;
      }
    }

    void handleRegister() async {
      errorMessage.value = null;

      if (!formKey3.currentState!.validate()) {
        return;
      }

      isLoading.value = true;

      final email = emailController.text.trim().toLowerCase();
      final password = passwordController.text;
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final phone = phoneController.text.trim().isEmpty
          ? null
          : phoneController.text.trim();
      final organizationName = organizationNameController.text.trim();
      final organizationType = selectedOrgType.value!;

      final registerDto = RegisterDto(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        organizationName: organizationName,
        organizationType: organizationType,
      );
      final response = await ref
          .read(authProvider.notifier)
          .register(registerDto);

      errorMessage.value = response.message;
      isLoading.value = false;
    }

    Widget buildStepIndicator() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          final isActive = index == currentStep.value;
          final isCompleted = index < currentStep.value;

          return Row(
            children: [
              Container(
                width: isActive ? 32 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isCompleted || isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              if (index < 2) const SizedBox(width: 8),
            ],
          );
        }),
      );
    }

    Widget buildStep1() {
      return Form(
        key: formKey1,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Account Information',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            LabelledField(
              labelText: 'Email Address',
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'john.doe@example.com',
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
            const SizedBox(height: 16),
            LabelledField(
              labelText: 'Password',
              child: TextFormField(
                controller: passwordController,
                obscureText: obscurePassword.value,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Min 8 characters',
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
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
                onFieldSubmitted: (_) => goToNextStep(),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildStep2() {
      return Form(
        key: formKey2,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            LabelledField(
              labelText: 'First Name',
              child: TextFormField(
                controller: firstNameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'John',
                  prefixIcon: Icon(Icons.person_outline, size: 20),
                ),
                validator: validateFirstName,
                onChanged: (_) {
                  if (errorMessage.value != null) {
                    errorMessage.value = null;
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            LabelledField(
              labelText: 'Last Name',
              child: TextFormField(
                controller: lastNameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Doe',
                  prefixIcon: Icon(Icons.person_outline, size: 20),
                ),
                validator: validateLastName,
                onChanged: (_) {
                  if (errorMessage.value != null) {
                    errorMessage.value = null;
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            LabelledField(
              labelText: 'Phone Number (Optional)',
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: '+254712345678',
                  prefixIcon: Icon(Icons.phone_outlined, size: 20),
                ),
                validator: validatePhone,
                onChanged: (_) {
                  if (errorMessage.value != null) {
                    errorMessage.value = null;
                  }
                },
                onFieldSubmitted: (_) => goToNextStep(),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildStep3() {
      return Form(
        key: formKey3,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Organization Details',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            LabelledField(
              labelText: 'Organization Name',
              child: TextFormField(
                controller: organizationNameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Green Valley Farm',
                  prefixIcon: Icon(Icons.business_outlined, size: 20),
                ),
                validator: validateOrganizationName,
                onChanged: (_) {
                  if (errorMessage.value != null) {
                    errorMessage.value = null;
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            LabelledField(
              labelText: 'Organization Type',
              child: DropdownButtonFormField<OrganizationType>(
                initialValue: selectedOrgType.value,
                decoration: const InputDecoration(
                  hintText: 'Select type',
                  prefixIcon: Icon(Icons.category_outlined, size: 20),
                ),
                items: OrganizationType.values.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type.label));
                }).toList(),
                onChanged: (value) {
                  selectedOrgType.value = value;
                  if (errorMessage.value != null) {
                    errorMessage.value = null;
                  }
                },
                validator: (value) => validateOrganizationType(value),
              ),
            ),
          ],
        ),
      );
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.energy_savings_leaf,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),

                    buildStepIndicator(),
                    const SizedBox(height: 32),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        key: ValueKey(currentStep.value),
                        child: currentStep.value == 0
                            ? buildStep1()
                            : currentStep.value == 1
                            ? buildStep2()
                            : buildStep3(),
                      ),
                    ),
                    const SizedBox(height: 24),

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
                    if (errorMessage.value != null) const SizedBox(height: 16),

                    Row(
                      children: [
                        if (currentStep.value > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: goToPreviousStep,
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text('Back'),
                            ),
                          ),
                        if (currentStep.value > 0) const SizedBox(width: 16),
                        Expanded(
                          flex: currentStep.value == 0 ? 1 : 1,
                          child: FilledButton(
                            onPressed: isLoading.value
                                ? null
                                : currentStep.value < 2
                                ? goToNextStep
                                : handleRegister,
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  )
                                : Text(
                                    currentStep.value < 2
                                        ? 'Next'
                                        : 'Create Account',
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
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
