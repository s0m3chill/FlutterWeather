import 'package:flutter/material.dart';
import 'package:flutter_weather/model/weather_data.dart';

import 'package:intl/intl.dart';

class WeatherWidget extends StatefulWidget {

  const WeatherWidget({Key key, this.weather}) : super(key: key);

  final WeatherData weather;

  @override
  State<StatefulWidget> createState() {
    return WeatherWidgetState();
  }
}

class WeatherWidgetState extends State<WeatherWidget> {

  //WeatherWidget({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FadeInImage.assetNetwork(placeholder: '',
            image: 'https://openweathermap.org/img/w/${widget.weather.icon}.png'),
        Text('${widget.weather.main}, ${widget.weather.temp.toInt().toString()}°C', style: new TextStyle(color: Colors.white, fontSize: 30.0)),
        RichText(
          text: new TextSpan(
            style: new TextStyle(
              fontSize: 14.0,
            ),
            children: <TextSpan>[
              new TextSpan(text: '${widget.weather.name}', style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.white)),
            ],
          ),
        ),
        Text(new DateFormat.yMMMd().format(widget.weather.date), style: new TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
        Text(new DateFormat.Hm().format(widget.weather.date), style: new TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
      ],
    );
  }

}