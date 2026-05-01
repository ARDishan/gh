import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/bloc/auth/auth_bloc.dart';
import '../../routes/app_routes.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/fonts.dart';
import '../../utils/theme/text_styles.dart';
import '../../utils/app_sizes.dart';
import '../../widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _imageAnimation;
  late Animation<double> _contentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _imageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _contentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final size = MediaQuery.of(context).size;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            // Hero image section
            AnimatedBuilder(
              animation: _imageAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _imageAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, -20 * (1 - _imageAnimation.value)),
                    child: child,
                  ),
                );
              },
              child: _HeroImageSection(height: size.height * 0.48),
            ),

            // Content section
            Expanded(
              child: AnimatedBuilder(
                animation: _contentAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _contentAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - _contentAnimation.value)),
                      child: child,
                    ),
                  );
                },
                child: _ContentSection(size: size),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroImageSection extends StatelessWidget {
  final double height;

  const _HeroImageSection({required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient background simulating building image
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1B4332),
                  Color(0xFF2D6A4F),
                  Color(0xFF40916C),
                  Color(0xFF74C69D),
                ],
              ),
            ),
          ),
          // Decorative elements to suggest a building
          Positioned.fill(
            child: CustomPaint(
              painter: _BuildingIllustrationPainter(),
            ),
          ),
          // Sun/light effect
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // GH Logo overlay
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'GH',
                          style: TextStyle(
                            fontFamily: AppFonts.playfair,
                            fontSize: 13,
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
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom gradient fade
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.white,
                    AppColors.white.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildingIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Windows grid
    paint.color = Colors.white.withOpacity(0.12);

    // Building body
    final buildingRect = Rect.fromLTWH(
      size.width * 0.3,
      size.height * 0.1,
      size.width * 0.4,
      size.height * 0.8,
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        buildingRect,
        topLeft: const Radius.circular(8),
        topRight: const Radius.circular(8),
      ),
      paint,
    );

    // Windows
    paint.color = Colors.white.withOpacity(0.2);
    const windowWidth = 12.0;
    const windowHeight = 10.0;
    const windowSpacingH = 20.0;
    const windowSpacingV = 18.0;

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 4; col++) {
        final x = buildingRect.left + 16 + col * windowSpacingH;
        final y = buildingRect.top + 20 + row * windowSpacingV;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, windowWidth, windowHeight),
            const Radius.circular(2),
          ),
          paint,
        );
      }
    }

    // Side wings
    paint.color = Colors.white.withOpacity(0.08);
    final leftWing = Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.3,
      size.width * 0.22,
      size.height * 0.6,
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        leftWing,
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      ),
      paint,
    );

    final rightWing = Rect.fromLTWH(
      size.width * 0.68,
      size.height * 0.25,
      size.width * 0.22,
      size.height * 0.65,
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rightWing,
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      ),
      paint,
    );

    // Green accents (plants/vertical garden)
    paint.color = const Color(0xFF52B788).withOpacity(0.4);
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(
          buildingRect.left - 10 + (i * 5),
          buildingRect.top + 100 + (i * 60),
        ),
        20,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ContentSection extends StatelessWidget {
  final Size size;

  const _ContentSection({required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.lg,
        AppSizes.sm,
        AppSizes.lg,
        AppSizes.lg,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Headline
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.displaySmall.copyWith(
                fontSize: 30,
                height: 1.2,
              ),
              children: [
                const TextSpan(
                  text: 'Ready to ',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                TextSpan(
                  text: 'Explore?',
                  style: TextStyle(
                    color: AppColors.primaryLight,
                    fontFamily: AppFonts.playfair,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.sm),

          Text(
            'Discover premium properties across Sri Lanka',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: AppSizes.lg),

          // Already have account button
          AppButton(
            label: 'ALREADY HAVE AN ACCOUNT',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
            prefixIcon: const Icon(
              Icons.login_rounded,
              color: AppColors.white,
              size: 18,
            ),
          ),

          const SizedBox(height: AppSizes.md),

          // Google button
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return _GoogleSignInButton(
                isLoading: state is AuthLoading,
                onPressed: () =>
                    context.read<AuthBloc>().add(AuthGoogleRequested()),
              );
            },
          ),

          const SizedBox(height: AppSizes.md),

          // OR divider
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.divider)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                child: Text(
                  'OR',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.grey400,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: AppColors.divider)),
            ],
          ),

          const SizedBox(height: AppSizes.md),

          // Continue as guest
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return AppButton(
                label: 'CONTINUE AS GUEST',
                onPressed: state is AuthLoading
                    ? null
                    : () => context.read<AuthBloc>().add(AuthGuestRequested()),
                style: AppButtonStyle.outline,
                isLoading: state is AuthLoading,
              );
            },
          ),

          const SizedBox(height: AppSizes.lg),

          // Register
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
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.register),
                child: Text(
                  'Register Now!',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),

          // Powered by
          const SizedBox(height: AppSizes.sm),
          Text(
            'Powered by Global Housing & Real Estate (Pvt) Ltd.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textHint,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _GoogleSignInButton({
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.buttonHeightLg,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.grey100,
          side: const BorderSide(color: AppColors.grey300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GoogleIcon(),
                  const SizedBox(width: AppSizes.sm),
                  Text(
                    'CONTINUE WITH GOOGLE',
                    style: AppTextStyles.buttonLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _GoogleIcon() {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'G',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4285F4),
            fontFamily: 'serif',
          ),
        ),
      ),
    );
  }
}