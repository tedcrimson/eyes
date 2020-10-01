import 'dart:async';
import 'dart:math';

import 'package:eyes/eye.dart';
import 'package:eyes/eyepainter.dart';
import 'package:flutter/material.dart';

class EyeController extends ValueNotifier<Offset> {
  EyeController(Offset value) : super(value);
}

class Eyes extends StatefulWidget {
  final bool openMode;
  final EyeController controller;

  const Eyes(this.controller, {this.openMode = true});
  @override
  _EyesState createState() => _EyesState();
}

class _EyesState extends State<Eyes> {
  // bool open = true;

  // Offset direction = Offset(0, 0);

  BoxConstraints size;

  StreamController<Offset> eyeBallUpdate = StreamController<Offset>();
  Stream<Offset> get eyeBallStream => eyeBallUpdate.stream;

  double lastValue = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      _calc();
    });
  }

  @override
  void dispose() {
    super.dispose();
    eyeBallUpdate.close();
  }

  _calc() {
    if (size == null || context == null) return;
    RenderBox rend = context.findRenderObject();
    var pos = widget.controller.value -
        rend.localToGlobal(
          Offset(
            size.maxWidth / 2,
            size.maxHeight / 2,
          ),
        );
    var dir = Offset.fromDirection(pos.direction);

    // direction = Offset(
    //   (dir.dx * pos.distance).clamp(-1.0, 1.0),
    //   (dir.dy * pos.distance).clamp(-1.0, 1.0),
    // );
    if (pos.distance < size.maxHeight / 2) {
      eyeBallUpdate.add(Offset.zero);
    } else {
      eyeBallUpdate.add(dir / pos.distance * 120);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      size = cons;

      return StreamBuilder<Offset>(
          stream: eyeBallStream,
          // initialData: Offset.zero,
          builder: (context, snapshot) {
            Offset direction = snapshot?.data ?? Offset.zero;
            bool selected = snapshot.hasData && direction.distance == 0;
            double start = lastValue;
            lastValue = max(0, 1 - direction.distance);
            return TweenAnimationBuilder(
              duration: Duration(milliseconds: 200),
              tween: Tween(begin: start, end: lastValue),
              builder: (BuildContext context, num value, Widget child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Expanded(
                    //   child: Eye(
                    //     size: Size(cons.maxWidth / 2 - 2, cons.maxHeight),
                    //     direction: direction,
                    //     selected: selected,
                    //     closed: widget.openMode ? null : max(0, 1 - direction.distance),
                    //   ),
                    // ),
                    Expanded(
                      child: CustomPaint(
                        painter: EyePainter(
                          // size: Size(cons.maxWidth / 2 - 2, cons.maxHeight),
                          direction: direction,
                          selected: selected,
                          opened: widget.openMode,
                          openValue: value,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: CustomPaint(
                        painter: EyePainter(
                          // size: Size(cons.maxWidth / 2 - 2, cons.maxHeight),
                          direction: direction,
                          selected: selected,
                          opened: widget.openMode,
                          openValue: value,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          });
    });
  }
}
