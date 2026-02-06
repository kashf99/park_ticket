import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_ticket/core/theme/app_colors.dart';
import 'package:park_ticket/core/utils/spacing.dart';

class HeaderRow extends StatelessWidget {
  final VoidCallback? onTicketTap;
  final bool showTicketButton;
  final String name;

  const HeaderRow({
    super.key,
    required this.name,
    this.onTicketTap,
    this.showTicketButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 44.r,
              width: 44.r,
              decoration: const BoxDecoration(
                color: AppColors.brand,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.place, color: Colors.white, size: 28),
            ),
            hSpaceM,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Park Ticket Entry',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.inkMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(name, style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
          ],
        ),
        // if (showTicketButton)
        //   OutlineChipButton(label: 'My Ticket', onPressed: onTicketTap),
      ],
    );
  }
}
