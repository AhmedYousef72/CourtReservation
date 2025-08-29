import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/helpers/navigation_helper.dart';
import '../item_detail/item_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showCourts = true; // true: courts, false: tools
  int _currentIndex = 0; // 0: Search, 1: Favorites, 2: Reservations, 3: Profile

  final List<_CatalogItem> _courts = [
    _CatalogItem(name: 'Court Juan', image: 'assets/court1.png', price: 5.0, location: 'Street 1, City', description: 'Great court with parking.'),
    _CatalogItem(name: 'P. Carolina', image: 'assets/court2.png', price: 0.0, location: 'Park, City 170506', description: 'Large park with multiple fields.'),
    _CatalogItem(name: 'Court Zzz', image: 'assets/court3.png', price: 8.0, location: 'Central Ave, City', description: 'Clean surface, good lighting.'),
    _CatalogItem(name: 'Court Pepe', image: 'assets/court4.png', price: 3.0, location: 'Calle N-76 1 y, Quito 170120', description: 'Excellent attention and parking.'),
  ];

  final List<_CatalogItem> _tools = [
    _CatalogItem(name: 'Skates', image: 'assets/patinag.png', price: 7.0),
    _CatalogItem(name: 'Volley Net', image: 'assets/rope.png', price: 1.0),
    _CatalogItem(name: 'Tennis Racket', image: 'assets/tennis.png', price: 10.0),
    _CatalogItem(name: 'Soccer Ball', image: 'assets/ball.png', price: 3.0),
  ];

  final List<_FavoriteEntry> _favorites = [];
  final List<ReservationEntry> _reservations = [];

  List<_CatalogItem> get _activeList => _showCourts ? _courts : _tools;

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
    if (result is DetailResult) {
      setState(() {
        if (result.addFavorite && !_favorites.any((f) => f.name == item.name)) {
          _favorites.add(_FavoriteEntry(name: item.name, image: item.image, price: item.price));
        }
        if (result.reservation != null) {
          _reservations.add(result.reservation!);
          _currentIndex = 2; // switch to reservations tab
        }
      });
    }
  }

  Widget _buildSearchTab() {
    final filtered = _activeList.where((e) {
      final q = _searchController.text.trim().toLowerCase();
      if (q.isEmpty) return true;
      return e.name.toLowerCase().contains(q);
    }).toList();

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Where do you want to go? (park - private court)',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
            ),
          ),
        ),

        // Toggle icons row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingLarge),
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

        const SizedBox(height: AppConstants.paddingSmall),

        // Title row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingLarge),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _showCourts ? 'For practice' : 'For rent',
                style: GoogleFonts.montserratAlternates(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff37B261),
                ),
              ),
              Text(
                'Price',
                style: GoogleFonts.montserratAlternates(
                  fontSize: 18,
                  color: AppConstants.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.paddingSmall),

        // Grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
            child: GridView.builder(
              itemCount: filtered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: .83,
              ),
              itemBuilder: (context, index) {
                final item = filtered[index];
                return _CatalogCard(
                  item: item,
                  onTap: () => _openDetail(item),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesTab() {
    if (_favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet', style: GoogleFonts.montserratAlternates(fontSize: 18)),
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
          onTap: () => _openDetail(_CatalogItem(name: f.name, image: f.image, price: f.price)),
        );
      },
    );
  }

  Widget _buildReservationsTab() {
    if (_reservations.isEmpty) {
      return Center(
        child: Text('No reservations yet', style: GoogleFonts.montserratAlternates(fontSize: 18)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      itemCount: _reservations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final r = _reservations[i];
        return ListTile(
          leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset(r.imagePath, width: 48, height: 48, fit: BoxFit.cover)),
          title: Text(
            r.itemName,
            style: GoogleFonts.montserratAlternates(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            '${r.time}  |  ${r.date.day.toString().padLeft(2, '0')}/${r.date.month.toString().padLeft(2, '0')}/${r.date.year}  |  US \$${r.price.toStringAsFixed(2)}',
            style: GoogleFonts.montserratAlternates(fontSize: 16),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => setState(() => _reservations.removeAt(i)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  width: 375,
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
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/titlelogo.png', fit: BoxFit.contain),
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
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
              child: _currentIndex == 0
                  ? _buildSearchTab()
                  : _currentIndex == 1
                      ? _buildFavoritesTab()
                      : _currentIndex == 2
                          ? _buildReservationsTab()
                          : Center(
                              child: Text('Profile', style: GoogleFonts.montserratAlternates(fontSize: 21, fontWeight: FontWeight.w600)),
                            ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: const Color(0xFF94E2AE),
        selectedItemColor: const Color(0xff1b56a8),
        unselectedItemColor: Colors.black87,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Catalog'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.event_available_outlined), label: 'Reserves'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
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
  const _CatalogItem({required this.name, required this.image, required this.price, this.location, this.description});
}

class _FavoriteEntry {
  final String name;
  final String image;
  final double price;
  const _FavoriteEntry({required this.name, required this.image, required this.price});
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
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              child: Text(
                item.name,
                style: GoogleFonts.montserratAlternates(fontSize: 18, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingSmall),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                  child: Image.asset(item.image, fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              child: Text(
                'Price  \$${item.price.toStringAsFixed(2)}',
                style: GoogleFonts.montserratAlternates(fontSize: 18, color: const Color(0xff1b56a8)),
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
  const _ToggleIcon({required this.label, required this.asset, required this.selected, required this.onTap});

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
              color: selected ? const Color(0xff37B261).withOpacity(.15) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xff37B261), width: 1),
            ),
            child: Image.asset(asset, fit: BoxFit.contain),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.montserratAlternates(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
