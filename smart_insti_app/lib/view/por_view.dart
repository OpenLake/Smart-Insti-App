import 'package:flutter/material.dart';
import '../model/por.dart';
import '../constants/text_styles.dart';

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
            style: TextStyles.title,
          ),
          Text(por.at),
          const Divider(),
        ],
      ),
    );
  }
}
