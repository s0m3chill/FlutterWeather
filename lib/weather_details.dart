
import 'package:flutter/material.dart';
import 'package:flutter_weather/view/drag_item.dart';

class WeatherDetails extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<WeatherDetails> {
  double totalWidth = 0.0;

  DragBox drag = DragBox(Offset(0.0, 0.0), 'Some annoying AD', Colors.blueAccent);

  @override
  Widget build(BuildContext context) {
  // Presentation: Scaffold distorts position
    return Scaffold(
      appBar: AppBar(title: new Text("Flutter Weather", style: new TextStyle(color: Colors.white)),),
      body:
       Stack(
        children: <Widget>[
          drag,
          Positioned(
            left: 0.0,
            bottom: 0.0,
            child: DragTarget(
              onAccept: (Color col) {
                  totalWidth += 30.0;
              },
              builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                  ) {
                return Container(
                  width: 200.0 + totalWidth,
                  height: 200.0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                );
              },
            ),
          )
        ],
      //)
    ),
    );
  }
}

