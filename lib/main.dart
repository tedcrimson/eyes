import 'dart:async';
import 'dart:math';

import 'package:eyes/eyes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EyeController controller = EyeController(Offset(0, 0));
  bool open = true;
  int get row => width ~/ 80;
  int get col => height ~/ 50;
  double width, height;
  var random = Random();

  int count = 0;
  bool moving = false;

  @override
  void initState() {
    super.initState();
    new Timer.periodic(Duration(seconds: 5), (Timer t) {
      _lookat();
    });
  }

  _lookat() {
    if (width != null && height != null && !moving) {
      int x = count % 2 == 0 ? row ~/ 2 : random.nextInt(row);
      int y = count % 2 == 0 ? col + 50 : random.nextInt(col);
      var w = ((x / row) * width) + (width / row / 2);
      var h = ((y / col) * height) + (height / col / 2);
      //    -(height / col / 2);
      controller.value = Offset(w, h);
      // print("$x,$y => $w $h =>> ${controller.value} ");
      count++;
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://media.giphy.com/media/MXQnyEQwBJ6eTj90L5/giphy.gif',
              fit: BoxFit.cover,
              color: Colors.black38,
              colorBlendMode: BlendMode.darken,
            ),
          ),
          if (width != null && height != null)
            Center(
              child: Listener(
                onPointerDown: (a) {
                  controller.value = a.position;
                  print(a.position);
                  moving = true;
                },
                onPointerMove: (a) {
                  controller.value = a.position;
                  // moving = true;
                },
                onPointerUp: (a) {
                  moving = false;
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    childAspectRatio: 3,
                    crossAxisCount: row,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    children: List.generate(row * col, (index) => Eyes(controller, openMode: open)),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(open ? Icons.remove_red_eye : Icons.fiber_manual_record),
          onPressed: () {
            setState(() {
              open = !open;
            });
          }),
    );
  }
}
