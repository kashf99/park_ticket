import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../utils/spacing.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Container(
            height: 40.r,
            width: 40.r,
            decoration: const BoxDecoration(
              color: Color(0xFFE9F1F6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.brand, size: 24),
          ),
          hSpaceM,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyMedium),
                vSpaceS,
                Text(value, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
