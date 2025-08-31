import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/helpers/responsive.dart';

class BookingDetailScreen extends StatelessWidget {
  final String itemName;
  final String imagePath;
  final double price;
  final DateTime date;
  final String time;
  final String bookedBy;
  final String location;

  const BookingDetailScreen({
    super.key,
    required this.itemName,
    required this.imagePath,
    required this.price,
    required this.date,
    required this.time,
    this.bookedBy = 'Guest',
    this.location = 'Quito 170506',
  });

  @override
  Widget build(BuildContext context) {
    final dateStr =
        "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff37B261),
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(
          'Details',
          style: GoogleFonts.montserratAlternates(
            fontSize: 21,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.horizontalPadding(context),
          vertical: Responsive.verticalPadding(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Responsive.maxContentWidth(context),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(height: Responsive.verticalPadding(context) * 0.5),

            // Price + name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  itemName,
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'US \$${price.toStringAsFixed(2)}',
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.verticalPadding(context) * 0.5),

            // Booking Details
            _sectionTitle('Booking Confirmation'),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff37B261), width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xff37B261),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Booking Confirmation',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: $dateStr'),
                        const SizedBox(height: 4),
                        const Text('Booking Status: Confirmed'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _sectionTitle('Booking Details'),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff37B261), width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xff37B261),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Booking Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                imagePath,
                                width: 80,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Court',
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(itemName),
                                Text('Cost: \$${price.toStringAsFixed(2)}'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Booked by',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(bookedBy),
                        Text('Location: $location'),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Check-in time\n$time',
                              style: const TextStyle(color: Colors.blue),
                            ),
                            const Text(
                              'Check-out time\n+1h',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.montserratAlternates(
          color: const Color(0xff37B261),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
