import 'package:flutter/material.dart';

class EyeClipper extends CustomClipper<Path> {
  final double closed;
  EyeClipper(this.closed);
  @override
  Path getClip(Size size) {
    var path = Path();
    // path.lineTo(0, 0);
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width - size.width / 4, size.height, size.width, size.height / 2);
    // path.lineTo(size.width, 0);
    // path.lineTo(0, 20);

    // path.lineTo(0, 0);
    // path.lineTo(0, 40);
    // path.quadraticBezierTo(size.width / 4, 0, size.width / 2, 0);
    path.quadraticBezierTo(size.width - size.width / 4, closed * (size.height), size.width / 2, closed * (size.height));
    path.quadraticBezierTo(size.width / 4, closed * (size.height), 0, size.height / 2);
    // path.lineTo(size.width, size.height);
    // path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(EyeClipper oldClipper) {
    return oldClipper.closed != closed;
  }
}
