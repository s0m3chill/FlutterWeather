import 'package:flutter/material.dart';

void main() => runApp(new FlutterWeather());

class FlutterWeather extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          backgroundColor: Colors.blueGrey,
          appBar: AppBar(
            title: Text('Flutter Weather App'),
          ),
          body: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Image.network('https://openweathermap.org/img/w/01d.png'),
                          Text('Sunny, 25 °C', style: new TextStyle(color: Colors.white, fontSize: 30.0)),
                          RichText(
                             text: new TextSpan(
                             style: new TextStyle(
                             fontSize: 14.0,
                            ),
                              children: <TextSpan>[
                               new TextSpan(text: 'LVIV', style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.white)),
                              ],
                            ),
                          ),
                          Text('Aug 20, 2018', style: new TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
                          Text('21:30', style: new TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                  ]
              )
          )
      ),
    );
  }
}
