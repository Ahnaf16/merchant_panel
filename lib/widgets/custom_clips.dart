import 'package:flutter/material.dart';

class DiscountClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.addPolygon([
      Offset(0, size.height / 2),
      Offset(size.width * 1 / 3, size.height),
      Offset(size.width, size.height),
      Offset(size.width, 0),
      Offset(size.width * 1 / 3, 0)
    ], false);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
