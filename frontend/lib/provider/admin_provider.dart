import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_insti_app/components/menu_tile.dart';

final adminProvider =
    StateNotifierProvider<AdminNotifier, AdminState>((ref) => AdminNotifier());

class AdminState {
  final bool toggleSearch;
  final TextEditingController searchController;
  final List<MenuTile> menuTiles;

  AdminState({
    required this.toggleSearch,
    required this.searchController,
    required this.menuTiles,
  });

  AdminState copyWith({
    bool? toggleSearch,
    TextEditingController? searchController,
    List<MenuTile>? menuTiles,
  }) {
    return AdminState(
        toggleSearch: toggleSearch ?? this.toggleSearch,
        searchController: searchController ?? this.searchController,
        menuTiles: menuTiles ?? this.menuTiles);
  }
}

class AdminNotifier extends StateNotifier<AdminState> {
  AdminNotifier()
      : super(AdminState(
          searchController: TextEditingController(),
          toggleSearch: false,
          menuTiles: [],
        ));

  get searchController => state.searchController;

  get toggleSearch => state.toggleSearch;

  get menuTiles => state.menuTiles;

  void buildMenuTiles(BuildContext context) {
    List<MenuTile> menuTiles = [
      MenuTile(
        title: "Add\nStudents",
        onTap: () => context.push('/admin_home/add_students'),
        icon: Icons.add,
        primaryColor: Colors.redAccent.shade100,
        secondaryColor: Colors.redAccent.shade200,
      ),
      MenuTile(
        title: "View\nStudents",
        onTap: () => context.push('/admin_home/view_students'),
        icon: Icons.add,
        primaryColor: Colors.greenAccent.shade100,
        secondaryColor: Colors.greenAccent.shade200,
      ),
      MenuTile(
        title: "Add\nCourses",
        onTap: () => context.push('/admin_home/add_courses'),
        icon: Icons.add,
        primaryColor: Colors.yellowAccent.shade100,
        secondaryColor: Colors.yellowAccent.shade200,
      ),
      MenuTile(
        title: "View\nCourses",
        onTap: () => context.push('/admin_home/view_courses'),
        icon: Icons.add,
        primaryColor: Colors.lightBlueAccent.shade100,
        secondaryColor: Colors.lightBlueAccent.shade200,
      ),
      MenuTile(
        title: "Add\nFaculty",
        onTap: () => context.push('/admin_home/add_faculty'),
        icon: Icons.add,
        primaryColor: Colors.purpleAccent.shade100,
        secondaryColor: Colors.purpleAccent.shade200,
      ),
      MenuTile(
        title: "View\nFaculty",
        onTap: () => context.push('/admin_home/view_faculty'),
        icon: Icons.add,
        primaryColor: Colors.orangeAccent.shade100,
        secondaryColor: Colors.orangeAccent.shade200,
      ),
      MenuTile(
        title: "Add\nMess\nMenu",
        onTap: () => context.push('/admin_home/add_menu'),
        icon: Icons.add,
        primaryColor: Colors.pinkAccent.shade100,
        secondaryColor: Colors.pinkAccent.shade200,
      ),
      MenuTile(
        title: "View\nMess\nMenu",
        onTap: () => context.push('/admin_home/view_menu'),
        icon: Icons.add,
        primaryColor: Colors.blueAccent.shade100,
        secondaryColor: Colors.blueAccent.shade200,
      ),
      MenuTile(
        title: "Manage\nRooms",
        onTap: () => context.push('/admin_home/manage_rooms'),
        icon: Icons.add,
        primaryColor: Colors.tealAccent.shade100,
        secondaryColor: Colors.tealAccent.shade200,
      ),
    ];
    String query = state.searchController.text;
    state = state.copyWith(
        menuTiles: menuTiles
            .where((element) =>
                element.title.toLowerCase().contains(query.toLowerCase()))
            .toList());
  }

  void toggleSearchBar() {
    state = state.copyWith(toggleSearch: !state.toggleSearch);
  }
}
