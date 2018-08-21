import 'package:flutter/material.dart';
import 'package:flutter_weather/model/weather_data.dart';

import 'package:intl/intl.dart';

class WeatherWidget extends StatelessWidget {

  final WeatherData weather;

  WeatherWidget({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.network('https://openweathermap.org/img/w/${weather.icon}.png'),
        Text('${weather.main}, ${weather.temp.toInt().toString()}°C', style: new TextStyle(color: Colors.white, fontSize: 30.0)),
        RichText(
          text: new TextSpan(
            style: new TextStyle(
              fontSize: 14.0,
            ),
            children: <TextSpan>[
              new TextSpan(text: '${weather.name}', style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.white)),
            ],
          ),
        ),
        Text(new DateFormat.yMMMd().format(weather.date), style: new TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
        Text(new DateFormat.Hm().format(weather.date), style: new TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
      ],
    );
  }

}