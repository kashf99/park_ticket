import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_ticket/core/network/api_client.dart';
import 'package:park_ticket/core/theme/app_colors.dart';
import 'package:park_ticket/core/utils/formatters.dart';
import 'package:park_ticket/features/attraction/domain/entities/attraction.dart';
import 'package:park_ticket/features/attraction/presentation/pages/attraction_page.dart';
import 'package:park_ticket/features/attraction/presentation/providers/attraction_provider.dart';

class AttractionListPage extends ConsumerWidget {
  const AttractionListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attractionsAsync = ref.watch(attractionsProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: attractionsAsync.when(
            data: (attractions) =>
                _AttractionListBody(attractions: attractions),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => _AttractionListError(
              message: _friendlyErrorMessage(error),
              onRetry: () => ref.refresh(attractionsProvider),
            ),
          ),
        ),
      ),
    );
  }
}

String _friendlyErrorMessage(Object error) {
  if (error is ApiException) {
    switch (error.type) {
      case ApiErrorType.timeout:
        return 'The server is taking too long to respond. Please try again.';
      case ApiErrorType.network:
        return 'No internet connection. Check your network and try again.';
      case ApiErrorType.badResponse:
        return 'We hit a server issue. Please try again in a moment.';
      case ApiErrorType.invalidResponse:
        return 'We received an unexpected response. Please try again.';
      case ApiErrorType.cancelled:
        return 'The request was cancelled. Please try again.';
      case ApiErrorType.unknown:
        return 'Something went wrong. Please try again.';
    }
  }
  return 'We could not load attractions. Please try again.';
}

class _AttractionListBody extends StatefulWidget {
  const _AttractionListBody({required this.attractions});

  final List<Attraction> attractions;

  @override
  State<_AttractionListBody> createState() => _AttractionListBodyState();
}

class _AttractionListBodyState extends State<_AttractionListBody> {
  late final TextEditingController _controller;
  String _query = '';
  final Set<String> _favoriteIds = <String>{};

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? widget.attractions
        : widget.attractions.where((attraction) {
            final name = attraction.name.toLowerCase();
            final description = attraction.description.toLowerCase();
            return name.contains(query) || description.contains(query);
          }).toList();

    return Column(
      children: [
        _AttractionListHeader(
          controller: _controller,
          onQueryChanged: (value) {
            setState(() {
              _query = value;
            });
          },
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            itemBuilder: (context, index) {
              final attraction = filtered[index];
              return _AttractionCard(
                attraction: attraction,
                isFavorite: _favoriteIds.contains(attraction.id),
                onFavoriteToggle: () {
                  setState(() {
                    if (_favoriteIds.contains(attraction.id)) {
                      _favoriteIds.remove(attraction.id);
                    } else {
                      _favoriteIds.add(attraction.id);
                    }
                  });
                },
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => AttractionPage(attraction: attraction),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 16.h),
            itemCount: filtered.length,
          ),
        ),
      ],
    );
  }
}

class _AttractionListHeader extends StatelessWidget {
  const _AttractionListHeader({
    required this.controller,
    required this.onQueryChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/icons/park_ticket_logo.png',
                width: 90.w,
                height: 28.h,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Park Ticket Explorer',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              _PillButton(
                label: 'English',
                icon: Icons.keyboard_arrow_down,
                onTap: () {},
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Container(
          //   height: 180.h,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(24.r),
          //     image: const DecorationImage(
          //       image: NetworkImage(
          //         'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1400&q=80',
          //       ),
          //       fit: BoxFit.cover,
          //     ),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withOpacity(0.15),
          //         blurRadius: 20,
          //         offset: const Offset(0, 12),
          //       ),
          //     ],
          //   ),
          //   child: Stack(
          //     children: [
          //       Positioned.fill(
          //         child: DecoratedBox(
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(24.r),
          //             gradient: LinearGradient(
          //               begin: Alignment.topCenter,
          //               end: Alignment.bottomCenter,
          //               colors: [
          //                 Colors.black.withOpacity(0.2),
          //                 Colors.black.withOpacity(0.5),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //       Positioned(
          //         left: 18.w,
          //         bottom: 18.h,
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               'Interactive Map',
          //               style: Theme.of(context).textTheme.headlineMedium
          //                   ?.copyWith(color: Colors.white),
          //             ),
          //             SizedBox(height: 6.h),
          //             Text(
          //               'Explore parks and attractions nearby',
          //               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          //                 color: Colors.white.withOpacity(0.85),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: TextField(
                    controller: controller,
                    onChanged: onQueryChanged,
                    decoration: InputDecoration(
                      hintText: 'Search places...',
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.search,
                        color: AppColors.inkMuted,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Icon(Icons.tune, color: AppColors.inkMuted, size: 20.sp),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  [
                    _FilterChip(
                      label: 'All',
                      icon: Icons.place,
                      isSelected: true,
                    ),
                    _FilterChip(
                      label: 'Attractions',
                      icon: Icons.camera_alt_outlined,
                    ),
                    _FilterChip(label: 'Food', icon: Icons.restaurant_outlined),
                    _FilterChip(
                      label: 'Shopping',
                      icon: Icons.shopping_bag_outlined,
                    ),
                    _FilterChip(label: 'Nature', icon: Icons.park_outlined),
                  ].map((chip) {
                    return Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: chip,
                    );
                  }).toList(),
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.icon,
    this.isSelected = false,
  });

  final String label;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected ? AppColors.ink : Colors.white;
    final textColor = isSelected ? Colors.white : AppColors.ink;
    final borderColor = isSelected ? Colors.transparent : AppColors.outline;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: textColor),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp),
            ),
            SizedBox(width: 6.w),
            Icon(icon, size: 18.sp),
          ],
        ),
      ),
    );
  }
}

class _AttractionCard extends StatelessWidget {
  const _AttractionCard({
    required this.attraction,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  final Attraction attraction;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(24.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.r),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: AppColors.outline),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.r),
                    ),
                    child: Image.network(
                      attraction.featuredImage,
                      height: 170.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 170.h,
                          color: AppColors.surface,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image, size: 40),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: GestureDetector(
                      onTap: onFavoriteToggle,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: isFavorite ? Colors.redAccent : AppColors.ink,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12.h,
                    left: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        formatPrice(attraction.price),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attraction.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      attraction.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16.sp,
                          color: AppColors.inkMuted,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '${formatTime(attraction.openingTime)} - ${formatTime(attraction.closingTime)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttractionListError extends StatelessWidget {
  const _AttractionListError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: AppColors.inkMuted),
            SizedBox(height: 12.h),
            Text(
              'Unable to load attractions',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}
