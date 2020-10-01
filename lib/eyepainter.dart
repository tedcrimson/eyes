import 'package:flutter/material.dart';

class EyePainter extends CustomPainter {
  final Size size;
  final Offset direction;
  final bool selected;
  final bool opened;
  final double openValue;
  EyePainter({this.size, this.direction, this.selected = false, this.opened, this.openValue});

  @override
  void paint(Canvas canvas, Size size) {
    Paint eyePainter = Paint();
    eyePainter.color = selected ? Colors.red[600] : Colors.black;
    // canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint)
    var eyeLidPath = _getPath(0, size);
    var eyeBallPath = _getPath(selected || opened ? 0 : openValue, size);
    canvas.drawPath(
      eyeLidPath,
      Paint()
        ..color = Colors.black26
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      eyeLidPath,
      Paint()
        ..color = Colors.black38
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke,
    );
    canvas.clipPath(eyeBallPath);

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.white);
    canvas.drawCircle(_getEyePosition(size, direction * (1 - openValue)),
        opened || selected ? size.height / 2 : size.width / 2 - (size.width * 0.2) * (1 - openValue), eyePainter);
  }

  @override
  bool shouldRepaint(EyePainter old) {
    return old.direction != direction || old.openValue != openValue;
  }

  Offset _getEyePosition(Size size, Offset direction) {
    double dx = size.width / 2 + (size.width / 2 * direction.dx);
    double dy = size.height / 2 + (size.height / 2 * direction.dy);
    double dxOffset = size.width / 4;
    double dyOffset = size.height / 4;
    return Offset(
      dx.clamp(dxOffset, size.width - dxOffset),
      dy.clamp(dyOffset, size.height - dyOffset),
    );
  }

  _getPath(double c, Size ss) {
    var path = Path();
    c = c > 0.9 ? 0.97 : c;
    path.moveTo(0, ss.height / 2);
    path.quadraticBezierTo(ss.width / 4, ss.height, ss.width / 2, ss.height);
    path.quadraticBezierTo(ss.width - ss.width / 4, ss.height, ss.width, ss.height / 2);

    path.quadraticBezierTo(ss.width - ss.width / 4, c * (ss.height), ss.width / 2, c * (ss.height));
    path.quadraticBezierTo(ss.width / 4, c * (ss.height), 0, ss.height / 2);
    return path;
  }
}
