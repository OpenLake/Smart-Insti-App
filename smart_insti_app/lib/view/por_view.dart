import 'package:flutter/material.dart';
import '../model/por.dart';
import '../constants/text_styles.dart';

class PorView extends StatelessWidget{
  final Por por;
  const PorView({super.key, required this.por});

  @override
  Widget build(BuildContext context){
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(width*0.005),
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
