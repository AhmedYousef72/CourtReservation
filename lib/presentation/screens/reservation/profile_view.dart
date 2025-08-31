import 'package:flutter/material.dart';
import '../item_detail/item_detail_screen.dart';
import 'booking_details_screen.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              color: Colors.green,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: const [
                  Icon(Icons.sports_soccer, color: Colors.white, size: 32),
                  SizedBox(width: 8),
                  Text('SportReserve', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Booking History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 10),

            // If navigated with a reservation list, render it
            Expanded(
              child: Builder(
                builder: (context) {
                  final args = ModalRoute.of(context)?.settings.arguments;
                  final reservations = args is List<ReservationEntry> ? args : <ReservationEntry>[];
                  if (reservations.isEmpty) {
                    return const Center(child: Text('No reservations yet'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: reservations.length,
                    itemBuilder: (context, i) {
                      final r = reservations[i];
                      final dateStr = "${r.date.day.toString().padLeft(2, '0')}/${r.date.month.toString().padLeft(2, '0')}/${r.date.year}";
                      return Card(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.green, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(r.imagePath, width: 48, height: 48, fit: BoxFit.cover),
                          ),
                          title: Text(r.itemName, style: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w500)),
                          subtitle: Text('$dateStr  |  ${r.time}  |  US \$${r.price.toStringAsFixed(2)}'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingDetailScreen(
                                  itemName: r.itemName,
                                  imagePath: r.imagePath,
                                  price: r.price,
                                  date: r.date,
                                  time: r.time,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
