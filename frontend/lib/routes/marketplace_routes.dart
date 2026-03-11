import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/marketplace/marketplace_screen.dart';
import '../screens/marketplace/add_listing_screen.dart';
import '../screens/marketplace/listing_detail.dart';
import '../screens/marketplace/wishlist_screen.dart';

final GoRoute marketplaceRoute = GoRoute(
  path: 'marketplace',
  pageBuilder: (context, state) =>
      const MaterialPage(child: MarketplaceScreen()),
  routes: [
    GoRoute(
      path: 'add',
      pageBuilder: (context, state) =>
          const MaterialPage(child: AddListingScreen()),
    ),
    GoRoute(
      path: 'detail/:id',
      pageBuilder: (context, state) => MaterialPage(
          child: ListingDetailScreen(listingId: state.pathParameters['id']!)),
    ),
    GoRoute(
      path: 'wishlist',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WishlistScreen()),
    ),
  ],
);
