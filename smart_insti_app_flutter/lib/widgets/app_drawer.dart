import 'package:flutter/material.dart';
import 'package:smart_insti_app_flutter/screens/feed_screen.dart';

import '../screens/calendar_screen.dart';

class AppDrawer extends StatelessWidget {
  final String name = 'Faiz Khan';
  final String year = '2nd year';
  final String urlImage =
      'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/hostedimages/1615295972i/30985332._SY540_.jpg';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(urlImage),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        year,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                ]),
          ),
          ListTile(
            title: const Text('Feed'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, FeedScreen.id);
            },
          ),
          ListTile(
            title: const Text('Calendar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, CalendarScreen.id);
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
