
import 'package:flutter/material.dart';
import 'package:flutter_weather/view/drag_item.dart';

class WeatherDetails extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<WeatherDetails> {
  Color caughtColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
  // Presentation: Scaffold distorts position
//    return Scaffold(
//      appBar: AppBar(title: new Text("Flutter Weather", style: new TextStyle(color: Colors.white)),),
//      body:
      return Stack(
        children: <Widget>[
          DragBox(Offset(0.0, 0.0), 'Box One', Colors.blueAccent),
          DragBox(Offset(200.0, 0.0), 'Box Two', Colors.orange),
          DragBox(Offset(300.0, 0.0), 'Box Three', Colors.lightGreen),
          Positioned(
            left: 100.0,
            bottom: 0.0,
            child: DragTarget(
              onAccept: (Color color) {
                caughtColor = color;
              },
              builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                  ) {
                return Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    color: accepted.isEmpty ? caughtColor : Colors.grey.shade200,
                  ),
                  child: Center(
                    child: Text("Drag Here!"),
                  ),
                );
              },
            ),
          )
        ],
      //)
    );

  }
}

