import 'package:flutter/material.dart';

class CollapsingAppBar extends StatelessWidget {
  const CollapsingAppBar({super.key, required this.title, required this.bottom});

  final String title;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      expandedHeight: 300,
      floating: true,
      pinned: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: bottom,
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
