import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:smart_insti_app/provider/room_provider.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/menu_tile.dart';
import '../models/student.dart';
import '../models/faculty.dart';

final homeProvider = StateNotifierProvider<UserProvider, HomeState>((ref) => UserProvider(ref));

class HomeState {
  final bool toggleSearch;
  final TextEditingController searchController;
  final List<MenuTile> menuTiles;

  HomeState({
    required this.toggleSearch,
    required this.searchController,
    required this.menuTiles,
  });

  HomeState copyWith({
    Student? student,
    Faculty? faculty,
    bool? toggleSearch,
    TextEditingController? searchController,
    List<MenuTile>? menuTiles,
  }) {
    return HomeState(
        toggleSearch: toggleSearch ?? this.toggleSearch,
        searchController: searchController ?? this.searchController,
        menuTiles: menuTiles ?? this.menuTiles);
  }
}

class UserProvider extends StateNotifier<HomeState> {
  UserProvider(Ref ref)
      : super(
          HomeState(
            searchController: TextEditingController(),
            toggleSearch: false,
            menuTiles: [],
          ),
        );

  get searchController => state.searchController;

  get toggleSearch => state.toggleSearch;

  get menuTiles => state.menuTiles;

  final Logger _logger = Logger();

  void buildMenuTiles(BuildContext context) {
    List<MenuTile> menuTiles = [
      MenuTile(
        title: 'Room Vacancy',
        onTap: () => context.push('/user_home/room_vacancy'),
        body: [
          Consumer(
            builder: (_, ref, __) => Text(
              '${ref.watch(roomProvider).roomList.where((element) => element.vacant).length} Vacant',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 11, color: UltimateTheme.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        icon: Icons.meeting_room_rounded,
        primaryColor: UltimateTheme.primary,
        secondaryColor: UltimateTheme.primary.withOpacity(0.2),
      ),
      MenuTile(
        title: "Lost & Found",
        onTap: () => context.push('/user_home/lost_and_found'),
        primaryColor: UltimateTheme.accent,
        secondaryColor: UltimateTheme.accent.withOpacity(0.2),
        icon: Icons.search_rounded,
      ),
      MenuTile(
        title: "Timetables",
        onTap: () => context.push('/user_home/timetables'),
        primaryColor: UltimateTheme.navy,
        secondaryColor: UltimateTheme.navy.withOpacity(0.2),
        icon: Icons.calendar_view_week_rounded,
      ),
      MenuTile(
        title: 'Broadcast',
        onTap: () => context.push('/user_home/broadcast'),
        icon: Icons.campaign_rounded,
        primaryColor: UltimateTheme.primary,
        secondaryColor: UltimateTheme.primary.withOpacity(0.2),
      ),
      MenuTile(
        title: "Chat Room",
        onTap: () => context.push('/user_home/chat_room'),
        primaryColor: UltimateTheme.accent,
        secondaryColor: UltimateTheme.accent.withOpacity(0.2),
        icon: Icons.forum_rounded,
      ),
      MenuTile(
        title: "Mess Menu",
        onTap: () => context.push('/user_home/mess_menu'),
        primaryColor: UltimateTheme.navy,
        secondaryColor: UltimateTheme.navy.withOpacity(0.2),
        icon: Icons.restaurant_menu_rounded,
      ),
      MenuTile(
        title: "Events",
        onTap: () => context.push('/user_home/events'),
        primaryColor: UltimateTheme.primary,
        secondaryColor: UltimateTheme.primary.withOpacity(0.2),
        icon: Icons.event_rounded,
      ),
      MenuTile(
        title: "Buzz & News",
        onTap: () => context.push('/user_home/news'),
        primaryColor: UltimateTheme.accent,
        secondaryColor: UltimateTheme.accent.withOpacity(0.2),
        icon: Icons.article_rounded,
      ),
      MenuTile(
        title: "Complaints",
        onTap: () => context.push('/user_home/complaints'),
        primaryColor: UltimateTheme.navy,
        secondaryColor: UltimateTheme.navy.withOpacity(0.2),
        icon: Icons.report_problem_rounded,
      ),
      MenuTile(
        title: "Quick Links",
        onTap: () => context.push('/user_home/links'),
        primaryColor: UltimateTheme.primary,
        secondaryColor: UltimateTheme.primary.withOpacity(0.2),
        icon: Icons.link_rounded,
      ),
    ];
    String query = state.searchController.text;
    state = state.copyWith(
        menuTiles: menuTiles.where((element) => element.title.toLowerCase().contains(query.toLowerCase())).toList());
  }

  void toggleSearchBar() {
    state = state.copyWith(toggleSearch: !state.toggleSearch);
  }
}
