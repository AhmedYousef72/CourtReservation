import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';

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
    '09:00', '10:00', '11:00', '12:00',
    '13:00', '14:00', '15:00', '16:00', '17:00',
  ];

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 60)),
      initialDate: _selectedDate,
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _reserve() {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a time slot')),
      );
      return;
    }
    final entry = ReservationEntry(
      itemName: widget.itemName,
      imagePath: widget.imagePath,
      date: _selectedDate,
      time: _selectedTime!,
      price: widget.price,
    );
    Navigator.pop(context, DetailResult(addFavorite: _isFavorite, reservation: entry));
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
        appBar: AppBar(
          backgroundColor: const Color(0xff37B261),
          foregroundColor: Colors.white,
          title: Text(
            widget.itemName,
            style: GoogleFonts.montserratAlternates(fontSize: 21, fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                child: Image.asset(widget.imagePath, height: 180, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: AppConstants.paddingMedium),

              // Price + Favorite
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'US \$${widget.price.toStringAsFixed(2)}',
                    style: GoogleFonts.montserratAlternates(fontSize: 21, fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _isFavorite = !_isFavorite),
                    icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                    color: _isFavorite ? Colors.red : Colors.black87,
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingSmall),

              // Location
              Text('Location', style: GoogleFonts.montserratAlternates(color: const Color(0xff37B261), fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.place_outlined, size: 20, color: Colors.black87),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.location ?? 'Park, City 00000',
                      style: GoogleFonts.montserratAlternates(fontSize: 18),
                    ),
                  ),
                  const Icon(Icons.my_location_outlined, size: 20),
                ],
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Description
              Text('Description', style: GoogleFonts.montserratAlternates(color: const Color(0xff37B261), fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                widget.description ?? 'Great court with availability. Basketball, tennis and skating tracks nearby.',
                style: GoogleFonts.montserratAlternates(fontSize: 18),
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Schedule
              Text('Schedule', style: GoogleFonts.montserratAlternates(color: const Color(0xff37B261), fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff37B261), foregroundColor: Colors.white),
                    onPressed: _pickDate,
                    child: Text(
                      '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                      style: GoogleFonts.montserratAlternates(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _timeSlots.map((slot) {
                  final selected = _selectedTime == slot;
                  return ChoiceChip(
                    label: Text(slot, style: GoogleFonts.montserratAlternates(fontSize: 18)),
                    selected: selected,
                    selectedColor: const Color(0xff37B261).withOpacity(0.15),
                    onSelected: (_) => setState(() => _selectedTime = slot),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: selected ? const Color(0xff37B261) : Colors.grey.shade400),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Reserve button
              SizedBox(
                width: double.infinity,
                height: AppConstants.buttonHeightMedium,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff37B261), foregroundColor: Colors.white),
                  onPressed: _reserve,
                  child: Text('Reserve', style: GoogleFonts.montserratAlternates(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
