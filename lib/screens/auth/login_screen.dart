import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/bloc/auth/auth_bloc.dart';
import '../../routes/app_routes.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/fonts.dart';
import '../../utils/theme/text_styles.dart';
import '../../utils/app_sizes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _onLogin(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: _emailController.text.trim(),
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
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
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
                  // Top decorative header
                  _LoginHeader(),

                  // Form content
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome text
                          Text(
                            'Welcome Back',
                            style: AppTextStyles.displaySmall.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSizes.xs),
                          Text(
                            'Sign in to continue exploring premium properties',
                            style: AppTextStyles.bodyMedium,
                          ),

                          const SizedBox(height: AppSizes.xl),

                          // Email field
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
                                FocusScope.of(context).requestFocus(_passwordFocus),
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

                          // Password field
                          AppTextField(
                            label: 'Password',
                            hint: 'Enter your password',
                            controller: _passwordController,
                            isPassword: true,
                            focusNode: _passwordFocus,
                            textInputAction: TextInputAction.done,
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              color: AppColors.grey500,
                              size: AppSizes.iconSm,
                            ),
                            onSubmitted: (_) => _onLogin(context),
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

                          // Remember me + Forgot password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      onChanged: (val) => setState(
                                        () => _rememberMe = val ?? false,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.xs),
                                  Text(
                                    'Remember me',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: Forgot password
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Forgot Password?',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primaryLight,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSizes.xl),

                          // Login button
                          AppButton(
                            label: 'SIGN IN',
                            onPressed: isLoading ? null : () => _onLogin(context),
                            isLoading: isLoading,
                          ),

                          const SizedBox(height: AppSizes.md),

                          // Divider
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(color: AppColors.divider),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.md,
                                ),
                                child: Text(
                                  'OR',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.grey400,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(color: AppColors.divider),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSizes.md),

                          // Guest login
                          AppButton(
                            label: 'CONTINUE AS GUEST',
                            onPressed: isLoading
                                ? null
                                : () => context
                                    .read<AuthBloc>()
                                    .add(AuthGuestRequested()),
                            style: AppButtonStyle.outline,
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ),

                          const SizedBox(height: AppSizes.xl),

                          // Register link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.register,
                                ),
                                child: Text(
                                  'Register Now',
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

class _LoginHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryLight,
                Color(0xFF52B788),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
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
              // Logo
              Positioned(
                bottom: 24,
                left: AppSizes.lg,
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'GH',
                          style: TextStyle(
                            fontFamily: AppFonts.playfair,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Global Housing',
                      style: TextStyle(
                        fontFamily: AppFonts.raleway,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Curved bottom
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