import 'package:flutter/material.dart';
import 'package:gh/routes/app_routes.dart';
import 'package:gh/utils/theme/colors.dart';
import 'package:gh/utils/theme/fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'BILLZAPP',
      routerConfig: appRouter,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        fontFamily: AppFonts.fontRegular,
      ),
    );
  }
}