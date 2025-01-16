import 'package:flutter/material.dart';

class MaterialContainer extends StatelessWidget {
  const MaterialContainer({super.key, required this.child, this.width, this.height});

  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.tealAccent.withOpacity(0.4),
      ),
      child: child,
    );
  }
}
