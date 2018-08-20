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
          backgroundColor: Colors.grey,
          appBar: AppBar(
            title: Text('Flutter Weather App'),
          ),
          body: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                        ],
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 450.0,
                          child: ListView.builder(
                              itemCount: 10,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) => Card(
                                color: Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              )
                          ),
                        ),
                      ),
                    )
                  ]
              )
          )
      ),
    );
  }
}
