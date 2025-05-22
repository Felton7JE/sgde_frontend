import 'package:cetic_sgde_front/restrict/pages/componets/sidebar.dart';
import 'package:cetic_sgde_front/main.dart';
import 'package:flutter/material.dart';

class Cards extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const Cards({Key? key, required this.title, required this.value, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double screenWidth = constraints.maxWidth;
        double fontSizeTitle = screenWidth < 300 ? 12 : 16;
        double fontSizeValue = screenWidth < 300 ? 18 : 24;
        double iconSize = screenWidth < 300 ? 24 : 32;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: canvasColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: iconSize, color: primaryColor),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: white.withOpacity(0.7),
                    fontSize: fontSizeTitle,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: white,
                    fontSize: fontSizeValue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}