import 'package:flutter/material.dart';
import 'package:flutter_weather/model/weather_data.dart';
import 'package:flutter_weather/utils/pivot_transition.dart';

import 'package:intl/intl.dart';

class WeatherWidget extends StatefulWidget {

  const WeatherWidget({Key key, this.weather}) : super(key: key);
//  You don't need to use Keys most of the time, '
//  'the framework handles it for you and uses them internally to differentiate between widgets. '
//  'There are a few cases where you may need to use them though.

//  if you have a child you want to access from a parent,
//  you can make a GlobalKey in the parent and pass it to the child's constructor. '
//  'Then you can do globalKey.state to get the child's state

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
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FadeInImage.assetNetwork(placeholder: '',
              image: 'https://openweathermap.org/img/w/${widget.weather.icon}.png'),
          Text('${widget.weather.main}, ${widget.weather.temp.toInt().toString()}°C', style: TextStyle(color: Colors.white, fontSize: 30.0)),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14.0,
              ),
              children: <TextSpan>[
                TextSpan(text: '${widget.weather.name}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.white)),
              ],
            ),
          ),
          Text(DateFormat.yMMMd().format(widget.weather.date), style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
          Text(DateFormat.Hm().format(widget.weather.date), style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
        ],
      ),
    );

//    return Center(
//      child:
//      PivotTransition(
//          turns: _animationController,
//          alignment: FractionalOffset.bottomRight,
//          child:
//          Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              FadeInImage.assetNetwork(placeholder: '',
//                  image: 'https://openweathermap.org/img/w/${widget.weather.icon}.png'),
//              Text('${widget.weather.main}, ${widget.weather.temp.toInt().toString()}°C', style: TextStyle(color: Colors.white, fontSize: 30.0)),
//              RichText(
//                text: TextSpan(
//                  style: TextStyle(
//                    fontSize: 14.0,
//                  ),
//                  children: <TextSpan>[
//                    TextSpan(text: '${widget.weather.name}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.white)),
//                  ],
//                ),
//              ),
//              Text(DateFormat.yMMMd().format(widget.weather.date), style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
//              Text(DateFormat.Hm().format(widget.weather.date), style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
//            ],
//          ),
//      ),
//    );
  }

}