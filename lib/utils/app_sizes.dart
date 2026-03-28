import 'package:flutter/material.dart';

class AppSizes {
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double paddingSmall = 8.0;
  static double paddingMedium = 16.0;
  static double paddingLarge = 24.0;

  static double responsiveFontSize(BuildContext context, double baseSize) {
    double width = screenWidth(context);
    if (width < 360) return baseSize * 0.9;
    if (width > 600) return baseSize * 1.2;
    return baseSize;
  }

  //sized box

  static const SizedBox h10 = SizedBox(height: 10);
  static const SizedBox h16 = SizedBox(height: 16);
  static const SizedBox h20 = SizedBox(height: 20);
  static const SizedBox h40 = SizedBox(height: 40);

  static const SizedBox w10 = SizedBox(width: 10);
  static const SizedBox w20 = SizedBox(width: 20);
  static const SizedBox w40 = SizedBox(width: 40);
}
