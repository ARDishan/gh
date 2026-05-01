import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/bloc/auth/auth_bloc.dart';
import '../../routes/app_routes.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/fonts.dart';
import '../../utils/theme/text_styles.dart';
import '../../utils/app_sizes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  void _onRegister(BuildContext context) {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms & Conditions'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      context.read<AuthBloc>().add(
            AuthRegisterRequested(
              fullName: _nameController.text.trim(),
              email: _emailController.text.trim(),
              phone: _phoneController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegistered) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
            ),
          );
          Future.delayed(const Duration(seconds: 1), () {
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            }
          });
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _RegisterHeader(),

                  // Form
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Account',
                            style: AppTextStyles.displaySmall,
                          ),
                          const SizedBox(height: AppSizes.xs),
                          Text(
                            'Join thousands finding their dream home',
                            style: AppTextStyles.bodyMedium,
                          ),

                          const SizedBox(height: AppSizes.xl),

                          // Full name
                          AppTextField(
                            label: 'Full Name',
                            hint: 'John Silva',
                            controller: _nameController,
                            focusNode: _nameFocus,
                            textInputAction: TextInputAction.next,
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                              color: AppColors.grey500,
                              size: AppSizes.iconSm,
                            ),
                            onSubmitted: (_) =>
                                FocusScope.of(context).requestFocus(_emailFocus),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Full name is required';
                              }
                              if (value.trim().length < 2) {
                                return 'Name must be at least 2 characters';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: AppSizes.md),

                          // Email
                          AppTextField(
                            label: 'Email Address',
                            hint: 'you@example.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            focusNode: _emailFocus,
                            textInputAction: TextInputAction.next,
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: AppColors.grey500,
                              size: AppSizes.iconSm,
                            ),
                            onSubmitted: (_) =>
                                FocusScope.of(context).requestFocus(_phoneFocus),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: AppSizes.md),

                          // Phone
                          AppTextField(
                            label: 'Phone Number',
                            hint: '+94 77 123 4567',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            focusNode: _phoneFocus,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9+\- ]'),
                              ),
                            ],
                            prefixIcon: const Icon(
                              Icons.phone_outlined,
                              color: AppColors.grey500,
                              size: AppSizes.iconSm,
                            ),
                            onSubmitted: (_) => FocusScope.of(context)
                                .requestFocus(_passwordFocus),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone number is required';
                              }
                              if (value.replaceAll(RegExp(r'[^0-9]'), '').length <
                                  9) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: AppSizes.md),

                          // Password
                          AppTextField(
                            label: 'Password',
                            hint: 'Minimum 6 characters',
                            controller: _passwordController,
                            isPassword: true,
                            focusNode: _passwordFocus,
                            textInputAction: TextInputAction.next,
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              color: AppColors.grey500,
                              size: AppSizes.iconSm,
                            ),
                            onSubmitted: (_) =>
                                FocusScope.of(context).requestFocus(_confirmFocus),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: AppSizes.md),

                          // Confirm password
                          AppTextField(
                            label: 'Confirm Password',
                            hint: 'Re-enter your password',
                            controller: _confirmPasswordController,
                            isPassword: true,
                            focusNode: _confirmFocus,
                            textInputAction: TextInputAction.done,
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              color: AppColors.grey500,
                              size: AppSizes.iconSm,
                            ),
                            onSubmitted: (_) => _onRegister(context),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: AppSizes.lg),

                          // Terms & Conditions
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  value: _agreeToTerms,
                                  onChanged: (val) => setState(
                                    () => _agreeToTerms = val ?? false,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSizes.sm),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                    children: [
                                      const TextSpan(text: 'I agree to the '),
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: TextStyle(
                                          color: AppColors.primaryLight,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: AppColors.primaryLight,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: ' of Global Housing & Real Estate.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSizes.xl),

                          // Register button
                          AppButton(
                            label: 'CREATE ACCOUNT',
                            onPressed:
                                isLoading ? null : () => _onRegister(context),
                            isLoading: isLoading,
                          ),

                          const SizedBox(height: AppSizes.xl),

                          // Login link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.login,
                                ),
                                child: Text(
                                  'Sign In',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSizes.lg),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RegisterHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 160,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1B4332),
                AppColors.primaryLight,
                Color(0xFF52B788),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -40,
                right: -20,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.07),
                  ),
                ),
              ),
              // Back button
              Positioned(
                top: MediaQuery.of(context).viewPadding.top + 8,
                left: 8,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              // Steps indicator
              Positioned(
                top: MediaQuery.of(context).viewPadding.top + 12,
                right: AppSizes.lg,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Step 1 of 1',
                    style: TextStyle(
                      fontFamily: AppFonts.inter,
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // Title
              Positioned(
                bottom: 24,
                left: AppSizes.lg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Join Us',
                      style: TextStyle(
                        fontFamily: AppFonts.playfair,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Global Housing & Real Estate',
                      style: TextStyle(
                        fontFamily: AppFonts.inter,
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.7),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
          ),
        ),
      ],
    );
  }
}