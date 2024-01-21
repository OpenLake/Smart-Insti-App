import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  const MenuTile(
      {super.key, required this.title, this.icon, required this.onTap, this.primaryColor ,this.secondaryColor });

  final String title;
  final IconData? icon;
  final Function onTap;
  final Color? primaryColor;
  final Color? secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color:primaryColor ?? Colors.grey[100],
          ),
          child: InkWell(
            overlayColor: MaterialStateProperty.all<Color?>(secondaryColor ?? Colors.grey[300]),
            borderRadius: BorderRadius.circular(15),
            splashColor: secondaryColor ?? Colors.grey[200],
            onTap: () => onTap(),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 21,
                  fontFamily: "GoogleSansFlex",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
