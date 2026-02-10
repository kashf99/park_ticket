
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:park_ticket/core/network/api_client.dart';

import '../../../booking/domain/entities/booking.dart';
import 'package:park_ticket/features/booking/di/booking_di.dart';
import '../../../ticket/domain/entities/ticket.dart';
import '../../../ticket/presentation/providers/ticket_session_provider.dart';
import '../../domain/entities/payment.dart';

const _paymentUnset = Object();

class PaymentFlowState {
  final bool isProcessing;
  final String? errorMessage;
  final Payment? payment;

  const PaymentFlowState({
    required this.isProcessing,
    required this.errorMessage,
    required this.payment,
  });

  factory PaymentFlowState.initial() {
    return const PaymentFlowState(
      isProcessing: false,
      errorMessage: null,
      payment: null,
    );
  }

  PaymentFlowState copyWith({
    bool? isProcessing,
    String? errorMessage,
    Object? payment = _paymentUnset,
  }) {
    return PaymentFlowState(
      isProcessing: isProcessing ?? this.isProcessing,
      errorMessage: errorMessage,
      payment:
          identical(payment, _paymentUnset) ? this.payment : payment as Payment?,
    );
  }
}

class PaymentFlowController extends AutoDisposeNotifier<PaymentFlowState> {
  @override
  PaymentFlowState build() => PaymentFlowState.initial();

  Future<void> confirm(Booking booking) async {
    if (_isAlreadyProcessing()) return;
    _startProcessing();
    try {
      final confirmedBooking = await _ensureBookingHasId(booking);
      _completePayment(confirmedBooking);
    } on ApiException catch (error) {
      if (error.type == ApiErrorType.unknown) {
        _completePayment(booking);
        return;
      }
      debugPrint('PaymentFlow ApiException: $error');
      _setError(error.toString());
    } catch (error) {
      debugPrint('PaymentFlow error: $error');
      _setError(error.toString());
    } finally {
      _stopProcessing();
    }
  }

  bool _isAlreadyProcessing() => state.isProcessing;

  void _startProcessing() {
    state = state.copyWith(
      isProcessing: true,
      errorMessage: null,
      payment: null,
    );
  }

  void _stopProcessing() {
    state = state.copyWith(isProcessing: false);
  }

  void _setError(String message) {
    state = state.copyWith(errorMessage: message);
  }

  Future<Booking> _ensureBookingHasId(Booking booking) async {
    if (booking.id.isNotEmpty) return booking;
    final createBooking = ref.read(createBookingProvider);
    return createBooking(booking);
  }

  // Future<Payment> _confirmPaymentForBooking(Booking booking) async {
  //   final confirmPayment = ref.read(confirmPaymentProvider);
  //   final payment = await confirmPayment(booking.id);
  //   return payment.copyWith(booking: payment.booking ?? booking);
  // }

  // Future<Ticket> _resolveTicket(Booking booking) async {
  //   final getTicket = ref.read(getTicketProvider);
  //   final lookup = booking.email.trim().isNotEmpty ? booking.email : booking.id;
  //   try {
  //     return await getTicket(lookup);
  //   } catch (_) {
  //     return _fallbackTicket(booking);
  //   }
  // }

  void _recordSuccessfulTicket({
    required Booking booking,
    required Ticket ticket,
  }) {
    ref.read(lastTicketBookingIdProvider.notifier).state = booking.id;
    final snapshot = TicketSnapshot(booking: booking, ticket: ticket);
    ref.read(lastTicketSnapshotProvider.notifier).state = snapshot;
    ref.read(ticketHistoryProvider.notifier).upsert(snapshot);
  }

  void _completePayment(Booking booking) {
    final finalizedBooking =
        booking.id.isEmpty ? _withBookingId(booking) : booking;
    final ticket = _fallbackTicket(finalizedBooking);
    final payment = Payment(
      bookingId: finalizedBooking.id,
      amountCents: finalizedBooking.totalCents,
      status: 'confirmed',
      booking: finalizedBooking,
      ticket: ticket,
    );
    state = state.copyWith(payment: payment, errorMessage: null);
    _recordSuccessfulTicket(booking: finalizedBooking, ticket: ticket);
  }
}

final paymentFlowControllerProvider =
    AutoDisposeNotifierProvider<PaymentFlowController, PaymentFlowState>(
      PaymentFlowController.new,
    );

String _fallbackBookingId() {
  final now = DateTime.now();
  return 'DF-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-SIM';
}

Booking _withBookingId(Booking booking) {
  return Booking(
    id: _fallbackBookingId(),
    attractionId: booking.attractionId,
    visitDate: booking.visitDate,
    timeSlot: booking.timeSlot,
    quantity: booking.quantity,
    name: booking.name,
    email: booking.email,
    totalCents: booking.totalCents,
    status: booking.status,
    qrToken: booking.qrToken,
    attractionName: booking.attractionName,
    totalAmount: booking.totalAmount,
    taxAmount: booking.taxAmount,
    finalAmount: booking.finalAmount,
    paymentReference: booking.paymentReference,
    qrCodeImage: booking.qrCodeImage,
  );
}

Ticket _fallbackTicket(Booking booking) {
  final tokenSeed = booking.id.isEmpty ? 'DF-SIM-0000' : booking.id;
  return Ticket(
    id: 'T-$tokenSeed',
    bookingId: booking.id,
    qrToken: 'QR-$tokenSeed',
    issuedAt: DateTime.now(),
    usedAt: null,
  );
}
