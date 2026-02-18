import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/listing.dart';
import '../models/student.dart';
import '../repositories/listing_repository.dart';
import 'auth_provider.dart';

final listingProvider = StateNotifierProvider<ListingNotifier, ListingState>((ref) {
  return ListingNotifier(ref);
});

class ListingState {
  final List<Listing> listings;
  final List<String> wishlistIds; // Store IDs of wishlisted items
  final bool isLoading;

  ListingState({
    this.listings = const [],
    this.wishlistIds = const [],
    this.isLoading = false,
  });

  ListingState copyWith({
    List<Listing>? listings,
    List<String>? wishlistIds,
    bool? isLoading,
  }) {
    return ListingState(
      listings: listings ?? this.listings,
      wishlistIds: wishlistIds ?? this.wishlistIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ListingNotifier extends StateNotifier<ListingState> {
  final Ref _ref;
  final ListingRepository _repository;

  ListingNotifier(this._ref)
      : _repository = _ref.read(listingRepositoryProvider),
        super(ListingState());

  Future<void> loadListings({String? category, String? search}) async {
    state = state.copyWith(isLoading: true);
    final authState = _ref.read(authProvider);
    final token = authState.token;
    
    if (token != null) {
      final listings = await _repository.getListings(token, category: category, search: search);
      
      // Sync wishlist from user profile
      List<String> wishlist = [];
      if (authState.currentUser is Student) {
          wishlist = (authState.currentUser as Student).wishlist;
      }
      
      state = state.copyWith(listings: listings, wishlistIds: wishlist, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> toggleWishlist(String id) async {
      final token = _ref.read(authProvider).token;
      if (token != null) {
          final success = await _repository.toggleWishlist(id, token);
          if (success) {
              final currentWishlist = List<String>.from(state.wishlistIds);
              if (currentWishlist.contains(id)) {
                  currentWishlist.remove(id);
              } else {
                  currentWishlist.add(id);
              }
              state = state.copyWith(wishlistIds: currentWishlist);
          }
      }
  }
}
