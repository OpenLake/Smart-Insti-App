import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_insti_app/components/collapsing_app_bar.dart';
import 'package:smart_insti_app/provider/admin_provider.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    AdminProvider adminProvider = Provider.of<AdminProvider>(context);
    return ResponsiveScaledBox(
      width: 411,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CollapsingAppBar(
                title: 'Welcome\nAdmin',
                bottom: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Consumer<AdminProvider>(
                    builder: (_, adminProvider, ___) {
                      if (adminProvider.toggleSearch) {
                        return SearchBar(
                          controller: adminProvider.searchController,
                          onChanged: (value) => adminProvider.refreshTiles(),
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              adminProvider.toggleSearchBar();
                              adminProvider.searchController.clear();
                              adminProvider.refreshTiles();
                            },
                          ),
                          shadowColor: MaterialStateProperty.all(Colors.transparent),
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                iconSize: 30,
                                onPressed: () => adminProvider.toggleSearchBar(),
                                icon: const Icon(Icons.search)),
                            PopupMenuButton(itemBuilder: (context){
                              return [
                                const PopupMenuItem(value: "about", child: Text("About Us")),
                                const PopupMenuItem(value: "logout", child: Text("Log Out")),
                              ];
                            }),
                          ],
                        );
                      }
                    },
                  ),
                ))
          ],
          body: Container(
            color: Colors.white,
            child: Consumer<AdminProvider>(
              builder: (_,__,___){
                return GridView.count(
                  padding: const EdgeInsets.all(10),
                  crossAxisCount: 2,
                  children: adminProvider.buildMenuTiles(context),
                );
              },
            )
          ),
        ),
      ),
    );
  }
}
