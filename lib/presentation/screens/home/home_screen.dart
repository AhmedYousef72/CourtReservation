import 'package:flutter/material.dart';
import '../reservation/booking_details_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../item_detail/item_detail_screen.dart';
import '../../../logic/navigation/nav_cubit.dart';
import '../../../logic/reservation/reservation_cubit.dart';
import '../../../logic/court/court_cubit.dart';
import '../../../data/models/court.dart';
import '../../../core/helpers/responsive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showCourts = true; // true: courts, false: tools

  // Hardcoded tools data (since we don't have tools in database yet)
  final List<_CatalogItem> _tools = [
    _CatalogItem(name: 'Skates', image: 'assets/patinag.png', price: 7.0),
    _CatalogItem(name: 'Volley Net', image: 'assets/rope.png', price: 1.0),
    _CatalogItem(
      name: 'Tennis Racket',
      image: 'assets/tennis.png',
      price: 10.0,
    ),
    _CatalogItem(name: 'Soccer Ball', image: 'assets/ball.png', price: 3.0),
  ];

  final List<_FavoriteEntry> _favorites = [];

  @override
  void initState() {
    super.initState();
    // Load courts from database when screen initializes
    context.read<CourtCubit>().loadCourts();
    // Load reservations from database
    context.read<ReservationCubit>().loadReservations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {});
  }

  Future<void> _openDetail(_CatalogItem item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItemDetailScreen(
          itemName: item.name,
          imagePath: item.image,
          price: item.price,
          location: item.location,
          description: item.description,
        ),
      ),
    );
    if (!mounted) return;
    if (result is DetailResult) {
      if (result.addFavorite && !_favorites.any((f) => f.name == item.name)) {
        setState(
          () => _favorites.add(
            _FavoriteEntry(
              name: item.name,
              image: item.image,
              price: item.price,
            ),
          ),
        );
      }
      if (result.reservation != null) {
        context.read<ReservationCubit>().addReservation(result.reservation!);
        context.read<NavCubit>().setIndex(2);
      }
    }
  }

  Future<void> _openCourtDetail(Court court) async {
    print('HomeScreen: Opening court detail for ${court.name}');
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItemDetailScreen(
            itemName: court.name,
            imagePath: court.imagePath,
            price: court.price,
            location: court.location,
            description: court.description,
          ),
        ),
      );
      print('HomeScreen: Navigation result received: $result');
      if (!mounted) return;
      if (result is DetailResult) {
        if (result.addFavorite &&
            !_favorites.any((f) => f.name == court.name)) {
          setState(
            () => _favorites.add(
              _FavoriteEntry(
                name: court.name,
                image: court.imagePath,
                price: court.price,
              ),
            ),
          );
        }
        if (result.reservation != null) {
          context.read<ReservationCubit>().addReservation(result.reservation!);
          context.read<NavCubit>().setIndex(2);
        }
      }
    } catch (e) {
      print('HomeScreen: Error opening court detail: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening court details: $e')),
      );
    }
  }

  Widget _buildSearchTab() {
    if (_showCourts) {
      // Show courts from database
      return BlocBuilder<CourtCubit, CourtState>(
        builder: (context, state) {
          if (state is CourtLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CourtLoaded) {
            final courts = state.courts;
            final filtered = courts.where((court) {
              final q = _searchController.text.trim().toLowerCase();
              if (q.isEmpty) return true;
              return court.name.toLowerCase().contains(q);
            }).toList();

            return _buildCourtGrid(filtered);
          } else if (state is CourtError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading courts',
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.read<CourtCubit>().loadCourts(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff37B261),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    } else {
      // Show tools (hardcoded)
      final filtered = _tools.where((e) {
        final q = _searchController.text.trim().toLowerCase();
        if (q.isEmpty) return true;
        return e.name.toLowerCase().contains(q);
      }).toList();

      return _buildToolsGrid(filtered);
    }
  }

  Widget _buildCourtGrid(List<Court> courts) {
    final hPad = Responsive.horizontalPadding(context);
    final vPad = Responsive.verticalPadding(context);
    final gridCount = Responsive.gridCrossAxisCount(context);

    return Column(
      children: [
        // Search bar
        Padding(
          padding: EdgeInsets.all(hPad * 0.75),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Where do you want to go? (park - private court)',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusMedium,
                ),
              ),
            ),
          ),
        ),

        // Toggle icons row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ToggleIcon(
                label: 'Sports areas',
                asset: 'assets/courtIcon.png',
                selected: _showCourts,
                onTap: () => setState(() => _showCourts = true),
              ),
              _ToggleIcon(
                label: 'Sports tools',
                asset: 'assets/toolIcon.png',
                selected: !_showCourts,
                onTap: () => setState(() => _showCourts = false),
              ),
            ],
          ),
        ),

        SizedBox(height: vPad * 0.5),

        // Title row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'For practice',
                style: GoogleFonts.montserratAlternates(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${courts.length} courts',
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: () => context.read<CourtCubit>().loadCourts(),
                    tooltip: 'Refresh courts',
                  ),
                  IconButton(
                    icon: const Icon(Icons.restore, size: 20),
                    onPressed: () =>
                        context.read<CourtCubit>().forceReinitializeData(),
                    tooltip: 'Re-initialize court data',
                  ),
                ],
              ),
            ],
          ),
        ),

        // Debug info (temporary)
        if (courts.length < 10)
          Container(
            margin: EdgeInsets.symmetric(horizontal: hPad, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Debug Info: Only ${courts.length}/10 courts loaded',
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap the restore button to re-initialize court data in Firebase',
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 12,
                    color: Colors.orange[700],
                  ),
                ),
              ],
            ),
          ),

        SizedBox(height: vPad * 0.5),

        // Courts grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(hPad),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: .83,
            ),
            itemCount: courts.length,
            itemBuilder: (context, index) {
              final court = courts[index];
              return _buildCourtCard(court);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildToolsGrid(List<_CatalogItem> tools) {
    final hPad = Responsive.horizontalPadding(context);
    final vPad = Responsive.verticalPadding(context);
    final gridCount = Responsive.gridCrossAxisCount(context);

    return Column(
      children: [
        // Search bar
        Padding(
          padding: EdgeInsets.all(hPad * 0.75),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search for sports equipment',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusMedium,
                ),
              ),
            ),
          ),
        ),

        // Toggle icons row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ToggleIcon(
                label: 'Sports areas',
                asset: 'assets/courtIcon.png',
                selected: _showCourts,
                onTap: () => setState(() => _showCourts = true),
              ),
              _ToggleIcon(
                label: 'Sports tools',
                asset: 'assets/toolIcon.png',
                selected: !_showCourts,
                onTap: () => setState(() => _showCourts = false),
              ),
            ],
          ),
        ),

        SizedBox(height: vPad * 0.5),

        // Title row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'For rent',
                style: GoogleFonts.montserratAlternates(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${tools.length} tools',
                style: GoogleFonts.montserratAlternates(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: vPad * 0.5),

        // Tools grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(hPad),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: .83,
            ),
            itemCount: tools.length,
            itemBuilder: (context, index) {
              final tool = tools[index];
              return _CatalogCard(item: tool, onTap: () => _openDetail(tool));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesTab() {
    if (_favorites.isEmpty) {
      return Center(
        child: Text(
          'No favorites yet',
          style: GoogleFonts.montserratAlternates(fontSize: 18),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      itemCount: _favorites.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final f = _favorites[i];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              f.image,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            f.name,
            style: GoogleFonts.montserratAlternates(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            'US \$${f.price.toStringAsFixed(2)}',
            style: GoogleFonts.montserratAlternates(fontSize: 16),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => setState(() => _favorites.removeAt(i)),
          ),
          onTap: () => _openDetail(
            _CatalogItem(name: f.name, image: f.image, price: f.price),
          ),
        );
      },
    );
  }

  Widget _buildReservationsTab() {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        return Column(
          children: [
            // Header with back icon
            Container(
              width: double.infinity,
              color: const Color(0xff37B261),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.read<NavCubit>().setIndex(0),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'My Reservations',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.reservations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_note_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No reservations yet',
                            style: GoogleFonts.montserratAlternates(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Book a court to see your reservations here',
                            style: GoogleFonts.montserratAlternates(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppConstants.paddingLarge),
                      itemCount: state.reservations.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final r = state.reservations[i];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                r.imagePath,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              r.itemName,
                              style: GoogleFonts.montserratAlternates(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  '${r.time}  |  ${r.date.day.toString().padLeft(2, '0')}/${r.date.month.toString().padLeft(2, '0')}/${r.date.year}',
                                  style: GoogleFonts.montserratAlternates(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'US \$${r.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.montserratAlternates(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff37B261),
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () =>
                                  context.read<ReservationCubit>().removeAt(i),
                            ),
                            onTap: () {
                              Navigator.push(
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
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCourtCard(Court court) {
    return GestureDetector(
      onTap: () {
        print('HomeScreen: Court card tapped for ${court.name}');
        _openCourtDetail(court);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(color: const Color(0xff37B261), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              child: Text(
                court.name,
                style: GoogleFonts.montserratAlternates(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingSmall,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusSmall,
                  ),
                  child: Image.asset(court.imagePath, fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              child: Text(
                'Price  \$${court.price.toStringAsFixed(2)}',
                style: GoogleFonts.montserratAlternates(
                  fontSize: 18,
                  color: const Color(0xff1b56a8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<NavCubit>().state;
    final hPad = Responsive.horizontalPadding(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header (height 66, width 375)
            Container(
              width: double.infinity,
              color: const Color(0xff37B261),
              child: Center(
                child: SizedBox(
                  width: Responsive.maxContentWidth(context),
                  height: 66,
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(hPad * 0.2),
                          child: Image.asset(
                            'assets/titlelogo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(width: hPad * 0.5),
                      Text(
                        'SportReserve',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content per tab
            Expanded(
              child: currentIndex == 0
                  ? _buildSearchTab()
                  : currentIndex == 1
                  ? _buildFavoritesTab()
                  : currentIndex == 2
                  ? _buildReservationsTab()
                  : Center(
                      child: Text(
                        'Profile',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => context.read<NavCubit>().setIndex(i),
        backgroundColor: const Color(0xFF94E2AE),
        selectedItemColor: const Color(0xff1b56a8),
        unselectedItemColor: Colors.black87,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Catalog'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available_outlined),
            label: 'Reserves',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class _CatalogItem {
  final String name;
  final String image;
  final double price;
  final String? location;
  final String? description;
  const _CatalogItem({
    required this.name,
    required this.image,
    required this.price,
    this.location,
    this.description,
  });
}

class _FavoriteEntry {
  final String name;
  final String image;
  final double price;
  const _FavoriteEntry({
    required this.name,
    required this.image,
    required this.price,
  });
}

class _CatalogCard extends StatelessWidget {
  final _CatalogItem item;
  final VoidCallback onTap;
  const _CatalogCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(color: const Color(0xff37B261), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              child: Text(
                item.name,
                style: GoogleFonts.montserratAlternates(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingSmall,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusSmall,
                  ),
                  child: Image.asset(item.image, fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              child: Text(
                'Price  \$${item.price.toStringAsFixed(2)}',
                style: GoogleFonts.montserratAlternates(
                  fontSize: 18,
                  color: const Color(0xff1b56a8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleIcon extends StatelessWidget {
  final String label;
  final String asset;
  final bool selected;
  final VoidCallback onTap;
  const _ToggleIcon({
    required this.label,
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xff37B261).withOpacity(.15)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xff37B261), width: 1),
            ),
            child: Image.asset(asset, fit: BoxFit.contain),
          ),
          const SizedBox(height: 6),
          Text(label, style: GoogleFonts.montserratAlternates(fontSize: 18)),
        ],
      ),
    );
  }
}
