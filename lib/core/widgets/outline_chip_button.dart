import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class OutlineChipButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const OutlineChipButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        side: const BorderSide(color: AppColors.outline, width: 1.2),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
