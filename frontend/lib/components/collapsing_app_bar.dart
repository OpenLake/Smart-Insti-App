import 'package:flutter/material.dart';

class CollapsingAppBar extends StatelessWidget {
  const CollapsingAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      expandedHeight: 300,
      floating: true,
      pinned: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                iconSize: 30, onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(
                iconSize: 30, onPressed: () {}, icon: const Icon(Icons.menu)),
          ],
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 36,
              fontFamily: "RobotoFlex",
            ),
          ),
        ),
      ),
    );
  }
}
