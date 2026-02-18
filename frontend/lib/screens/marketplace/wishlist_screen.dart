import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../theme/ultimate_theme.dart';
import '../../provider/listing_provider.dart';
import '../../models/listing.dart';

class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends ConsumerState<WishlistScreen> {

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
    final wishlistItems = state.listings.where((l) => state.wishlistIds.contains(l.id)).toList();

    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Text("My Wishlist", style: GoogleFonts.outfit(color: UltimateTheme.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
      ),
      body: state.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : wishlistItems.isEmpty
            ? Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text("Your wishlist is empty", style: GoogleFonts.outfit(fontSize: 18, color: Colors.grey)),
                ],
            ))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: wishlistItems.length,
                itemBuilder: (context, index) {
                    final listing = wishlistItems[index];
                    return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                        color: UltimateTheme.surfaceColor,
                        child: InkWell(
                            onTap: () => context.push('/user_home/marketplace/detail/${listing.id}'),
                            borderRadius: BorderRadius.circular(16),
                            child: Row(
                                children: [
                                    Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                                            color: Colors.grey[200],
                                            image: listing.images.isNotEmpty 
                                                ? DecorationImage(image: NetworkImage(listing.images[0]), fit: BoxFit.cover)
                                                : null,
                                        ),
                                        child: listing.images.isEmpty 
                                            ? const Center(child: Icon(Icons.image_not_supported, color: Colors.grey))
                                            : null,
                                    ),
                                    Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    Text(listing.title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                                                    const SizedBox(height: 4),
                                                    Text("₹${listing.price}", style: GoogleFonts.outfit(color: UltimateTheme.primaryColor, fontWeight: FontWeight.bold)),
                                                ],
                                            ),
                                        ),
                                    ),
                                    IconButton(
                                        icon: const Icon(Icons.favorite, color: Colors.red),
                                        onPressed: () {
                                            ref.read(listingProvider.notifier).toggleWishlist(listing.id);
                                        },
                                    )
                                ],
                            ),
                        ),
                    );
                },
            ),
    );
  }
}
