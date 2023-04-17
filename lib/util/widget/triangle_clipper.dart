import 'package:flutter/material.dart';

class TriangleClipper extends CustomClipper<Path> {
  final double triangleWidth;

  TriangleClipper(this.triangleWidth);

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(triangleWidth, h);
    path.lineTo(w - triangleWidth, h);
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
