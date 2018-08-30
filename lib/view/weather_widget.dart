import 'package:flutter/material.dart';
import 'package:flutter_weather/model/weather_data.dart';
import 'package:flutter_weather/utils/pivot_transition.dart';

import 'package:intl/intl.dart';

class WeatherWidget extends StatefulWidget {

  const WeatherWidget({Key key, this.weather}) : super(key: key);

  final WeatherData weather;

  @override
  State<StatefulWidget> createState() {
    return WeatherWidgetState();
  }
}

class WeatherWidgetState extends State<WeatherWidget> with TickerProviderStateMixin {

  AnimationController _animationController;

  @override initState() {
    super.initState();
    _animationController = new AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );//..repeat();

    _animationController.forward();
  }

  @override dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: new PivotTransition(
          turns: _animationController,
          alignment: FractionalOffset.bottomRight,
          child:
          Column(
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
          ),
      ),
    );
  }

}