import 'package:gh/screens/onboarding/splash_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path:   '/', builder: (context, state) => const SplashScreen()),
  ],
);
