import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SquareTile extends StatelessWidget {

  final String imagePath;

  const SquareTile({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[200],
      ),
      child: Image.asset(
          imagePath,
        height: 40,
        width: 40,
      ),
    );
  }
}
