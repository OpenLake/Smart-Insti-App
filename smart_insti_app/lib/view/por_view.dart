import 'package:flutter/material.dart';
import '../model/por.dart';

class PorView extends StatelessWidget{
  final Por por;
  const PorView({super.key, required this.por});

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            por.position,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(por.at),
          const Divider(),
        ],
      ),
    );
  }
}
