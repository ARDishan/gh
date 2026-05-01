import 'package:flutter/material.dart';
import '../utils/theme/colors.dart';
import '../utils/theme/text_styles.dart';
import '../utils/app_sizes.dart';

enum AppButtonStyle { primary, secondary, outline, ghost, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;
  final double? width;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = AppButtonStyle.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
    this.width,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius = AppSizes.radiusLg,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? AppSizes.buttonHeightLg,
      width: isFullWidth ? double.infinity : width,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    switch (style) {
      case AppButtonStyle.primary:
        return _PrimaryButton(
          label: label,
          onPressed: isLoading ? null : onPressed,
          isLoading: isLoading,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          borderRadius: borderRadius,
          backgroundColor: backgroundColor,
          textColor: textColor,
        );
      case AppButtonStyle.outline:
        return _OutlineButton(
          label: label,
          onPressed: isLoading ? null : onPressed,
          isLoading: isLoading,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          borderRadius: borderRadius,
        );
      case AppButtonStyle.secondary:
        return _SecondaryButton(
          label: label,
          onPressed: isLoading ? null : onPressed,
          isLoading: isLoading,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          borderRadius: borderRadius,
        );
      case AppButtonStyle.ghost:
        return _GhostButton(
          label: label,
          onPressed: isLoading ? null : onPressed,
          isLoading: isLoading,
          prefixIcon: prefixIcon,
          borderRadius: borderRadius,
        );
      case AppButtonStyle.danger:
        return _PrimaryButton(
          label: label,
          onPressed: isLoading ? null : onPressed,
          isLoading: isLoading,
          prefixIcon: prefixIcon,
          borderRadius: borderRadius,
          backgroundColor: AppColors.error,
          textColor: AppColors.white,
        );
    }
  }
}

class _ButtonContent extends StatelessWidget {
  final String label;
  final bool isLoading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color labelColor;

  const _ButtonContent({
    required this.label,
    required this.isLoading,
    required this.labelColor,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          color: labelColor,
          strokeWidth: 2.5,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefixIcon != null) ...[
          prefixIcon!,
          const SizedBox(width: AppSizes.sm),
        ],
        Text(
          label,
          style: AppTextStyles.buttonLarge.copyWith(color: labelColor),
        ),
        if (suffixIcon != null) ...[
          const SizedBox(width: AppSizes.sm),
          suffixIcon!,
        ],
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;

  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.prefixIcon,
    this.suffixIcon,
    required this.borderRadius,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: textColor ?? AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      child: _ButtonContent(
        label: label,
        isLoading: isLoading,
        labelColor: textColor ?? AppColors.white,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double borderRadius;

  const _OutlineButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.prefixIcon,
    this.suffixIcon,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: _ButtonContent(
        label: label,
        isLoading: isLoading,
        labelColor: AppColors.primary,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double borderRadius;

  const _SecondaryButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.prefixIcon,
    this.suffixIcon,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.grey200,
        foregroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0,
      ),
      child: _ButtonContent(
        label: label,
        isLoading: isLoading,
        labelColor: AppColors.textPrimary,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? prefixIcon;
  final double borderRadius;

  const _GhostButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.prefixIcon,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: _ButtonContent(
        label: label,
        isLoading: isLoading,
        labelColor: AppColors.primary,
        prefixIcon: prefixIcon,
      ),
    );
  }
}