
import 'package:flutter/material.dart';
import 'package:flutter_weather/view/drag_item.dart';
import 'package:flutter_weather/model/weather_data.dart';

class WeatherDetails extends StatefulWidget {

  WeatherData weather;

  WeatherDetails({Key key, @required this.weather}) : super(key: key);

  @override
  AppState createState() => AppState();
}

class AppState extends State<WeatherDetails> {
  double widthDifference = 0.0;
  bool shouldShowHiddenInfo = false;
  final widthStep = 100.0;

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
//          Positioned(
//            left: 0.0,
//            bottom: 0.0,
//            child: DragTarget(
//              onAccept: (Color col) {
//                  widthDifference += widthStep;
//                  if (widthDifference >= widthStep * 3) {
//                    shouldShowHiddenInfo = true;
//                  }
//              },
//              builder: (
//                  BuildContext context,
//                  List<dynamic> accepted,
//                  List<dynamic> rejected,
//                  ) {
//                return Column(
//                  children: <Widget>[
//                    Container(
//                      width: MediaQuery.of(context).size.width,
//                      height: 50.0,
//                      child: Align(
//                        alignment: Alignment.center,
//                        child: Opacity(opacity: shouldShowHiddenInfo ? 1.0 : 0.0,
//                        child: Text('The weather is: ${widget.weather.main}'))
//                      ),
//                    ),
//                    Opacity(
//                      opacity: shouldShowHiddenInfo ? 0.0 : 1.0,
//                      child: Container(
//                        width: MediaQuery.of(context).size.width - widthDifference,
//                        height: 200.0,
//                        decoration: BoxDecoration(
//                          color: Colors.black,
//                        ),
//                      ),
//                    )
//                  ],
//                );
//              },
//            ),
//          ),
        ],
      //)
    ),
    );
  }
}

