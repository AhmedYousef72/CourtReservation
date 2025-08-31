import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/helpers/responsive.dart';
import '../../../logic/reservation/reservation_cubit.dart';
import '../../../data/models/court.dart';

class DetailResult {
  final bool addFavorite;
  final ReservationEntry? reservation;
  const DetailResult({this.addFavorite = false, this.reservation});
}

class ReservationEntry {
  final String itemName;
  final String imagePath;
  final DateTime date;
  final String time;
  final double price;
  const ReservationEntry({
    required this.itemName,
    required this.imagePath,
    required this.date,
    required this.time,
    required this.price,
  });
}

class ItemDetailScreen extends StatefulWidget {
  final String itemName;
  final String imagePath;
  final double price;
  final String? location;
  final String? description;
  const ItemDetailScreen({
    super.key,
    required this.itemName,
    required this.imagePath,
    required this.price,
    this.location,
    this.description,
  });

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  bool _isFavorite = false;

  final List<String> _timeSlots = const [
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
  ];

  // Track which time slots are available/unavailable
  final Set<String> _unavailableSlots = {'12:00', '13:00', '14:00', '16:00'};

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 60)),
      initialDate: _selectedDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff37B261),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _selectTime(String time) {
    if (!_unavailableSlots.contains(time)) {
      setState(() => _selectedTime = time);
    }
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
  }

  void _reserve() {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose a time slot'),
          backgroundColor: Color(0xff37B261),
        ),
      );
      return;
    }

    // Create reservation entry
    final entry = ReservationEntry(
      itemName: widget.itemName,
      imagePath: widget.imagePath,
      date: _selectedDate,
      time: _selectedTime!,
      price: widget.price,
    );

    // Add to Firebase via ReservationCubit
    context.read<ReservationCubit>().addReservation(entry);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reservation successful for ${widget.itemName}'),
        backgroundColor: const Color(0xff37B261),
        duration: const Duration(seconds: 2),
      ),
    );

    // Navigate back with result
    Navigator.pop(
      context,
      DetailResult(addFavorite: _isFavorite, reservation: entry),
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context, DetailResult(addFavorite: _isFavorite));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.itemName,
            style: GoogleFonts.montserratAlternates(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xff37B261),
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding(context),
            vertical: Responsive.verticalPadding(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Court Image
              _buildCourtImage(),
              const SizedBox(height: 20),

              // Price and Favorite
              _buildPriceAndFavorite(),
              const SizedBox(height: 20),

              // Location Section
              _buildLocationSection(),
              const SizedBox(height: 20),

              // Description Section
              _buildDescriptionSection(),
              const SizedBox(height: 30),

              // Schedule Section
              _buildScheduleSection(),
              const SizedBox(height: 30),

              // Reserve Button
              _buildReserveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourtImage() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(widget.imagePath, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildPriceAndFavorite() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'US \$${widget.price.toStringAsFixed(2)}',
          style: GoogleFonts.montserratAlternates(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Column(
          children: [
            IconButton(
              onPressed: _toggleFavorite,
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : Colors.grey,
                size: 28,
              ),
            ),
            const Icon(
              Icons.location_on_outlined,
              color: Colors.grey,
              size: 24,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: GoogleFonts.montserratAlternates(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xff37B261),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.location ?? 'Location not available',
          style: GoogleFonts.montserratAlternates(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: GoogleFonts.montserratAlternates(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xff37B261),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.description ?? 'No description available',
          style: GoogleFonts.montserratAlternates(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Schedule',
              style: GoogleFonts.montserratAlternates(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xff37B261),
              ),
            ),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff37B261),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Time slots grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          itemCount: _timeSlots.length,
          itemBuilder: (context, index) {
            final time = _timeSlots[index];
            final isUnavailable = _unavailableSlots.contains(time);
            final isSelected = _selectedTime == time;

            return GestureDetector(
              onTap: () => _selectTime(time),
              child: Container(
                decoration: BoxDecoration(
                  color: isUnavailable
                      ? Colors.grey[300]
                      : isSelected
                      ? const Color(0xff37B261)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isUnavailable
                        ? Colors.grey[400]!
                        : isSelected
                        ? const Color(0xff37B261)
                        : const Color(0xff37B261),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    time,
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isUnavailable
                          ? Colors.grey[600]
                          : isSelected
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildReserveButton() {
    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.only(bottom: 20),
      child: ElevatedButton(
        onPressed: _reserve,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff37B261),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          'Reserve',
          style: GoogleFonts.montserratAlternates(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
