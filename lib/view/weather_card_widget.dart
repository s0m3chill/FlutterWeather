import 'package:flutter/material.dart';
import 'package:flutter_weather/model/weather_data.dart';

import 'package:intl/intl.dart';


class WeatherCardWidget extends StatefulWidget {

  const WeatherCardWidget({Key key, this.weather}) : super(key: key);

  final WeatherData weather;

  @override
  State<StatefulWidget> createState() {
    return WeatherCardState();
  }

}

class WeatherCardState extends State<WeatherCardWidget> {

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeInImage.assetNetwork(placeholder: '',
                image: 'https://openweathermap.org/img/w/${widget.weather.icon}.png'),
            Text('${widget.weather.main}, ${widget.weather.temp.toInt().toString()}°C', style: new TextStyle(color: Colors.white, fontSize: 30.0)),
            Text(new DateFormat.yMMMd().format(widget.weather.date), style: new TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
            Text(new DateFormat.Hm().format(widget.weather.date), style: new TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

}