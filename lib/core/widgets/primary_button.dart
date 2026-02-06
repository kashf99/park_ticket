import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? trailingIcon;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.ink,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (trailingIcon != null) ...[
            hSpaceS,
            Icon(trailingIcon, size: 18),
          ],
        ],
      ),
    );
  }
}
