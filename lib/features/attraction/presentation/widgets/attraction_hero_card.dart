import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/spacing.dart';
import '../../../../core/widgets/section_card.dart';

class AttractionHeroCard extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;

  const AttractionHeroCard({
    super.key,
    required this.title,
    required this.description,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: _HeroBackground(imageUrl: imageUrl)),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(153, 222, 243, 252),
                    Color.fromARGB(204, 97, 222, 241),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            left: 18.w,
            right: 18.w,
            bottom: 18.h,
            child: SectionCard(
              padding: EdgeInsets.all(18.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 28,
                        width: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE9F1F6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: AppColors.brand,
                          size: 18,
                        ),
                      ),
                      hSpaceS,
                      Text(
                        'Premium experience • Mobile ticket',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  vSpaceS,
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  vSpaceS,
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBackground extends StatelessWidget {
  final String? imageUrl;

  const _HeroBackground({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final image = imageUrl?.trim();
    if (image == null || image.isEmpty) {
      return const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB4C9C4), Color(0xFF0C7489)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      );
    }

    return Image.network(
      image,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB4C9C4), Color(0xFF0C7489)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      },
    );
  }
}
