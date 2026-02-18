import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../theme/ultimate_theme.dart';
import '../../provider/listing_provider.dart';

class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = ['All', 'Electronics', 'Books', 'Furniture', 'Stationery', 'Other'];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(listingProvider.notifier).loadListings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(listingProvider);
    final listings = state.listings;

    return Scaffold(
        backgroundColor: UltimateTheme.backgroundColor,
        appBar: AppBar(
        title: Text("Marketplace", style: GoogleFonts.outfit(color: UltimateTheme.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
        actions: [
            IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
                context.push('/user_home/marketplace/wishlist');
            },
            ),
            IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
                // Navigate to Order History
            },
            )
        ],
        ),
        body: Column(
        children: [
            // Search & Filter
            Container(
            padding: const EdgeInsets.all(16),
            color: UltimateTheme.surfaceColor,
            child: Column(
                children: [
                TextField(
                    controller: _searchController,
                    onSubmitted: (value) {
                        ref.read(listingProvider.notifier).loadListings(search: value, category: _selectedCategory);
                    },
                    decoration: InputDecoration(
                    hintText: "Search items...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: UltimateTheme.backgroundColor,
                    ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                    children: _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                            setState(() => _selectedCategory = category);
                            ref.read(listingProvider.notifier).loadListings(category: category, search: _searchController.text);
                            },
                            backgroundColor: UltimateTheme.backgroundColor,
                            selectedColor: UltimateTheme.primaryColor.withOpacity(0.2),
                            labelStyle: GoogleFonts.outfit(
                            color: isSelected ? UltimateTheme.primaryColor : UltimateTheme.textSub,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), 
                            side: BorderSide(color: isSelected ? UltimateTheme.primaryColor : Colors.transparent)
                            ),
                        ),
                        );
                    }).toList(),
                    ),
                ),
                ],
            ),
            ),
            
            // Listings Grid
            Expanded(
            child: state.isLoading 
                ? const Center(child: CircularProgressIndicator())
                : listings.isEmpty
                    ? Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        const Icon(Icons.storefront, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text("No items found", style: GoogleFonts.outfit(fontSize: 18, color: Colors.grey)),
                        ],
                    ))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        ),
                        itemCount: listings.length,
                        itemBuilder: (context, index) {
                        return _buildListingCard(listings[index]);
                        },
                    ),
            ),
        ],
        ),
        floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
             context.push('/user_home/marketplace/add');
        },
        backgroundColor: UltimateTheme.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text("Sell Item", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
    );
  }

  Widget _buildListingCard(dynamic listing) {
    return GestureDetector(
      onTap: () {
          context.push('/user_home/marketplace/detail/${listing.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: UltimateTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  color: Colors.grey[200],
                  image: listing.images.isNotEmpty 
                      ? DecorationImage(image: NetworkImage(listing.images[0]), fit: BoxFit.cover)
                      : null,
                ),
                child: listing.images.isEmpty 
                    ? const Center(child: Icon(Icons.image_not_supported, color: Colors.grey))
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "₹${listing.price}",
                    style: GoogleFonts.outfit(color: UltimateTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          listing.sellerName, // Should come from seller info
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
