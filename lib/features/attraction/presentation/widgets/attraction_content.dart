import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:park_ticket/core/utils/formatters.dart';
import 'package:park_ticket/core/utils/spacing.dart';
import 'package:park_ticket/core/widgets/info_tile.dart';
import 'package:park_ticket/core/widgets/primary_button.dart';
import 'package:park_ticket/core/widgets/section_card.dart';
import 'package:park_ticket/features/attraction/domain/entities/attraction.dart';
import 'package:park_ticket/features/attraction/presentation/widgets/attraction_hero_card.dart';
import 'package:park_ticket/features/attraction/presentation/widgets/header_row.dart';
import 'package:park_ticket/features/booking/presentation/pages/booking_page.dart';
import 'package:park_ticket/features/ticket/presentation/pages/ticket_confirmation_page.dart';
import 'package:park_ticket/features/ticket/presentation/providers/ticket_session_provider.dart';

class AttractionContent extends ConsumerWidget {
  final Attraction attraction;

  const AttractionContent({
    super.key,
    required this.attraction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastTicketBookingId = ref.watch(lastTicketBookingIdProvider);
    final hasTicket = lastTicketBookingId != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth < 500 ? 16.w : 28.w;
        final contentWidth = constraints.maxWidth > 720
            ? 720.0
            : constraints.maxWidth;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 18.h,
          ),
          child: Center(
            child: SizedBox(
              width: contentWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderRow(
                    name: attraction.name,
                    showTicketButton: hasTicket,
                    onTicketTap: hasTicket
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    const TicketConfirmationPage(),
                              ),
                            );
                          }
                        : null,
                  ),
                  vSpaceM,

                  AttractionHeroCard(
                    title: attraction.name,
                    description: attraction.description,
                    imageUrl: attraction.featuredImage,
                  ),
                  vSpaceM,
                  InfoTile(
                    icon: Icons.schedule,
                    label: 'Opening time',
                    value: formatTime(attraction.openingTime),
                  ),
                  vSpaceM,
                  InfoTile(
                    icon: Icons.schedule,
                    label: 'Closing time',
                    value: formatTime(attraction.closingTime),
                  ),
                  vSpaceM,
                  InfoTile(
                    icon: Icons.confirmation_number,
                    label: 'Ticket price',
                    value: formatPrice(attraction.price),
                  ),
                  vSpaceM,
                  SectionCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Plan your visit',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              vSpaceS,
                              Text(
                                'Choose date, time, and number of tickets.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        hSpaceS,
                        PrimaryButton(
                          label: 'Book Ticket',
                          trailingIcon: Icons.arrow_forward,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    BookingPage(attraction: attraction),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
