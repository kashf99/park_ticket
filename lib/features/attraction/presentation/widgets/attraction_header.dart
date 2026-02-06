import 'package:flutter/material.dart';
import '../../../../core/utils/spacing.dart';

class AttractionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AttractionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        vSpaceS,
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
