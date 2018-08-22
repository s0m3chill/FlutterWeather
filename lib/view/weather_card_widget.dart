import 'package:flutter/material.dart';
import 'package:flutter_weather/model/weather_data.dart';

import 'package:intl/intl.dart';

class WeatherCardWidget extends StatelessWidget {

  final WeatherData weather;

  WeatherCardWidget({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network('https://openweathermap.org/img/w/${weather.icon}.png'),
            Text('${weather.main}, ${weather.temp.toInt().toString()}°C', style: new TextStyle(color: Colors.white, fontSize: 30.0)),
            Text(new DateFormat.yMMMd().format(weather.date), style: new TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

}