import 'package:flutter/material.dart';
import 'por_view.dart';
import '../model/por.dart';

class UserInfoPorsView extends StatelessWidget{
  final List<Por> pors;
  const UserInfoPorsView(this.pors, {super.key});

  @override
  Widget build(BuildContext context){
    return ListView(
      children: pors.isNotEmpty ? 
        pors.map((por){
          return PorView(por: por);
        }).toList()
      : <Widget>[],
    );
  }
}
