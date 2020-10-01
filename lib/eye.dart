import 'dart:math';

import 'package:eyes/eye_clipper.dart';
import 'package:flutter/material.dart';

class Eye extends StatelessWidget {
  final Size size;
  final Offset direction;
  final bool selected;
  final double closed;
  Eye({this.size, this.direction, this.selected = false, this.closed});
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: EyeClipper(0),
      clipBehavior: Clip.hardEdge,
      child: Container(
        color: Colors.black26,
        child: ClipPath(
          clipper: EyeClipper(
            selected ? 0 : closed ?? 0,
          ),
          child: Container(
            // duration: Duration(milliseconds: 500),
            // width: size.width ,
            // height: selected ? size.height : size.height * direction.distance,
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                AnimatedPositioned.fromRect(
                  rect: Rect.fromCircle(
                    center: _getEyePosition(size, direction),
                    // radius: size.height/2
                    radius: closed == null || selected
                        ? size.height / 2
                        : size.width / 2 - (size.width * 0.2) * (1 - closed),
                  ),
                  // left: 100,
                  // right: 100,
                  // top: 20,
                  duration: Duration(milliseconds: (500 * (closed ?? 0.5)).toInt()),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected ? Colors.red[600] : Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
}
