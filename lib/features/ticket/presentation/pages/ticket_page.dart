import 'package:flutter/material.dart';

class TicketPage extends StatelessWidget {
  const TicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket'),
      ),
      body: const Center(
        child: Text('Ticket Confirmation Placeholder'),
      ),
    );
  }
}
