import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/bloc/auth/auth_bloc.dart';
import '../../routes/app_routes.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _taglineOpacity;
  late Animation<Offset> _taglineSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          context.read<AuthBloc>().add(AuthCheckRequested());
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: CustomPaint(
                painter: _SplashPatternPainter(),
              ),
            ),
            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _logoOpacity,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: child,
                        ),
                      );
                    },
                    child: _buildLogo(),
                  ),
                  const SizedBox(height: 32),
                  // Tagline
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _taglineOpacity,
                        child: SlideTransition(
                          position: _taglineSlide,
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          'YOUR DREAM HOME AWAITS',
                          style: TextStyle(
                            fontFamily: AppFonts.raleway,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white.withAlpha((255*0.7).round()),
                            letterSpacing: 3.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 40,
                          height: 2,
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bottom branding
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _taglineOpacity.value,
                    child: child,
                  );
                },
                child: Column(
                  children: [
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.primaryAccent,
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Powered by Global Housing & Real Estate',
                      style: TextStyle(
                        fontFamily: AppFonts.inter,
                        fontSize: 11,
                        color: AppColors.white.withAlpha((255*0.5).round()),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.white.withAlpha((255*0.12).round()),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.white.withAlpha((255*0.3).round()),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'GHR',
                  style: TextStyle(
                    fontFamily: AppFonts.playfair,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Global Housing',
          style: TextStyle(
            fontFamily: AppFonts.playfair,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '& Real Estate',
          style: TextStyle(
            fontFamily: AppFonts.raleway,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.white.withAlpha((255*0.8).round()),
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }
}

class _SplashPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha((255*0.04).round())
      ..style = PaintingStyle.fill;

    // Large circle top right
    canvas.drawCircle(
      Offset(size.width + 60, -60),
      200,
      paint,
    );

    // Medium circle bottom left
    canvas.drawCircle(
      Offset(-80, size.height + 40),
      180,
      paint,
    );

    // Small circles
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.2), 40, paint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.75), 60, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}