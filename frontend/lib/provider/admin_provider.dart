import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_insti_app/components/menu_tile.dart';



class AdminProvider extends ChangeNotifier{

  bool toggleSearch = false;
  late BuildContext context;
  final TextEditingController _searchController = TextEditingController();

  TextEditingController get searchController => _searchController;



  void refreshTiles(){
    notifyListeners();
  }

  List<MenuTile> buildMenuTiles(BuildContext context){
    List<MenuTile> menuTiles = [
      MenuTile(
        title: "Add\nStudents",
        onTap: () => context.push('/add_students'),
        icon: Icons.add,
        primaryColor: Colors.redAccent.shade100,
        secondaryColor: Colors.redAccent.shade200,
      ),
      MenuTile(
        title: "View\nStudents",
        onTap: () => context.push('/view_students'),
        icon: Icons.add,
        primaryColor: Colors.greenAccent.shade100,
        secondaryColor: Colors.greenAccent.shade200,
      ),
      MenuTile(
        title: "Add\nCourses",
        onTap: () => context.push('/add_courses'),
        icon: Icons.add,
        primaryColor: Colors.yellowAccent.shade100,
        secondaryColor: Colors.yellowAccent.shade200,
      ),
      MenuTile(
        title: "View\nCourses",
        onTap: () => context.push('/view_courses'),
        icon: Icons.add,
        primaryColor: Colors.lightBlueAccent.shade100,
        secondaryColor: Colors.lightBlueAccent.shade200,
      ),
      MenuTile(
        title: "Add\nFaculty",
        onTap: () => context.push('/add_faculty'),
        icon: Icons.add,
        primaryColor: Colors.purpleAccent.shade100,
        secondaryColor: Colors.purpleAccent.shade200,
      ),
      MenuTile(
        title: "View\nFaculty",
        onTap: () => context.push('/view_faculty'),
        icon: Icons.add,
        primaryColor: Colors.orangeAccent.shade100,
        secondaryColor: Colors.orangeAccent.shade200,
      ),
      MenuTile(
        title: "Add\nMess\nMenu",
        onTap: () => context.push('/add_menu'),
        icon: Icons.add,
        primaryColor: Colors.pinkAccent.shade100,
        secondaryColor: Colors.pinkAccent.shade200,
      ),
      MenuTile(
        title: "View\nMess\nMenu",
        onTap: () => context.push('/view_menu'),
        icon: Icons.add,
        primaryColor: Colors.blueAccent.shade100,
        secondaryColor: Colors.blueAccent.shade200,
      ),
      MenuTile(
        title: "Manage\nRooms",
        onTap: () => context.push('/manage_rooms'),
        icon: Icons.add,
        primaryColor: Colors.tealAccent.shade100,
        secondaryColor: Colors.tealAccent.shade200,
      ),
    ];
    String query = _searchController.text;
    return menuTiles.where((element) => element.title.toLowerCase().contains(query.toLowerCase())).toList();
  }

  void toggleSearchBar(){
    toggleSearch = !toggleSearch;
    notifyListeners();
  }
}