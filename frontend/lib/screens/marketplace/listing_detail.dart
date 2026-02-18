import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/ultimate_theme.dart';
import '../../provider/listing_provider.dart';
import '../../models/listing.dart';

class ListingDetailScreen extends ConsumerStatefulWidget {
  final String listingId;

  const ListingDetailScreen({super.key, required this.listingId});

  @override
  ConsumerState<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends ConsumerState<ListingDetailScreen> {
  // We can fetch from provider list or single fetch.
  // Using list for now as we likely came from list.
  
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(listingProvider);
    // Find listing in list
    final listing = state.listings.firstWhere(
        (l) => l.id == widget.listingId, 
        orElse: () => Listing(id: '', title: '', description: '', price: 0, category: '', condition: '', images: [], sellerId: '', sellerName: '', sellerImage: '', status: '', createdAt: DateTime.now())
    );

    if (listing.id.isEmpty) {
         // Optionally fetch single listing here if deep linked
         // For now show loader or error
         return const Scaffold(body: Center(child: Text("Listing not found or loading...")));
    }
    
    final isWishlisted = state.wishlistIds.contains(listing.id);

    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: listing.images.isNotEmpty
                  ? Image.network(listing.images[0], fit: BoxFit.cover)
                  : Container(color: Colors.grey[300], child: const Icon(Icons.image, size: 64, color: Colors.grey)),
            ),
            actions: [
                IconButton(
                    icon: Icon(isWishlisted ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                    onPressed: () {
                        ref.read(listingProvider.notifier).toggleWishlist(listing.id);
                    },
                )
            ]
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        listing.title,
                        style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "₹${listing.price}",
                      style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: UltimateTheme.primaryColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                      child: Text(listing.category, style: GoogleFonts.outfit(color: Colors.blue)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
                      child: Text(listing.condition, style: GoogleFonts.outfit(color: Colors.green)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text("Description", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(listing.description, style: GoogleFonts.outfit(fontSize: 16, color: Colors.grey[800], height: 1.5)),
                
                const SizedBox(height: 32),
                Text("Seller", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                      backgroundImage: listing.sellerImage.isNotEmpty ? NetworkImage(listing.sellerImage) : null,
                      child: listing.sellerImage.isEmpty ? Text(listing.sellerName[0]) : null
                  ),
                  title: Text(listing.sellerName),
                  subtitle: Text("Verified Student"), // Placeholder
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                    // Contact seller
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: UltimateTheme.primaryColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Chat", style: GoogleFonts.outfit(color: UltimateTheme.primaryColor, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                    // Buy Now
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: UltimateTheme.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Buy Now", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
