import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_insti_app/components/collapsing_app_bar.dart';
import 'package:smart_insti_app/components/menu_tile.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) =>
              [const CollapsingAppBar(title: 'Welcome\nAdmin')],
          body: Container(
            color: Colors.white,
            child: GridView.count(
              padding: const EdgeInsets.all(10),
              crossAxisCount: 2,
              children: [
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
                  title: "Mess\nMenu",
                  onTap: () => context.push('/mess_menu'),
                  icon: Icons.add,
                  primaryColor: Colors.pinkAccent.shade100,
                  secondaryColor: Colors.pinkAccent.shade200,
                ),
                MenuTile(
                  title: "Add\nMess Menu",
                  onTap: () => context.push('/add_mess_menu'),
                  icon: Icons.add,
                  primaryColor: Colors.blueAccent.shade100,
                  secondaryColor: Colors.blueAccent.shade200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
