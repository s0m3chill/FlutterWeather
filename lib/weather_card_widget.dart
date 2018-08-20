import 'package:flutter/material.dart';

class WeatherCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}