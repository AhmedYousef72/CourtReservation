import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/authentication/auth_cubit.dart';
import '../reservation/booking_details_screen.dart';
import '../../../core/helpers/responsive.dart';

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
                children: [
                  const Icon(
                    Icons.sports_soccer,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "SportReserve",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is Authenticated) {
                        return PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          onSelected: (value) {
                            if (value == 'signout') {
                              context.read<AuthCubit>().signOut();
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'signout',
                              child: Row(
                                children: const [
                                  Icon(Icons.logout, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Sign Out'),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // User Info Section
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.green,
                              child: Text(
                                state.user.name?.substring(0, 1).toUpperCase() ?? 
                                state.user.email.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.user.name ?? 'User',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    state.user.email,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  if (state.user.phoneNumber != null)
                                    Text(
                                      state.user.phoneNumber!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildStatItem('Favorites', state.user.favorites.length.toString()),
                            const SizedBox(width: 20),
                            _buildStatItem('Reservations', state.user.reservations.length.toString()),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 20),

            // Search Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Where do you want to go?",
                  helperText: "park - private court",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Booking History Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Booking History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            // History List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildHistoryItem(
                    context: context,
                    date: "July 29, 2024",
                    title: "Skates",
                    icon: Icons.sports, // inline skating placeholder
                  ),
                  _buildHistoryItem(
                    context: context,
                    date: "July 29, 2024",
                    title: "Carolina Court",
                    icon: Icons.sports_basketball,
                  ),
                  _buildHistoryItem(
                    context: context,
                    date: "July 19, 2024",
                    title: "Soccer Ball",
                    icon: Icons.sports_soccer,
                  ),
                  _buildHistoryItem(
                    context: context,
                    date: "July 20, 2024",
                    title: "Pepe Court",
                    icon: Icons.sports_tennis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem({
    required String date,
    required String title,
    required IconData icon,
    required BuildContext context,
  }) {
    // Choose list icon from assets: courts use courtIcon, tools use toolIcon
    final bool isCourt = title.toLowerCase().contains('court');
    final String iconAsset = isCourt ? 'assets/courtIcon.png' : 'assets/toolIcon.png';

    // Map title to the same image used in Home/Details screens
    final String imagePath = _imageForTitle(title);

    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.green, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Image.asset(iconAsset, width: 32, height: 32, fit: BoxFit.contain),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(date),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingDetailScreen(
                itemName: title,
                imagePath: imagePath,
                price: 0.0,
                date: DateTime.now(),
                time: '09:00',
              ),
            ),
          );
        },
      ),
    );
  }
}

String _imageForTitle(String title) {
  final lower = title.toLowerCase();
  if (lower.contains('carolina') && lower.contains('court')) return 'assets/court2.png';
  if (lower.contains('pepe') && lower.contains('court')) return 'assets/court4.png';
  if (lower.contains('juan') && lower.contains('court')) return 'assets/court1.png';
  if (lower.contains('zzz') && lower.contains('court')) return 'assets/court3.png';
  if (lower.contains('skate')) return 'assets/patinag.png';
  if (lower.contains('soccer') && lower.contains('ball')) return 'assets/ball.png';
  if (lower.contains('tennis')) return 'assets/tennis.png';
  if (lower.contains('volley') || lower.contains('net')) return 'assets/rope.png';
  // Default: a court image
  return 'assets/court1.png';
}
