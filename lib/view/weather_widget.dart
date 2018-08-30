import 'package:flutter/material.dart';
import 'package:flutter_weather/model/weather_data.dart';

import 'package:intl/intl.dart';

import 'dart:ui';
import 'dart:math' as math;

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
    )..repeat();

//  _animationController = AnimationController(
//    duration: Duration(seconds: 3),
//    vsync: this,
//  );
//  _animationController.repeat(period: Duration(seconds: 3)).then( (fdsf) => ( _animationController.stop(true) ) );
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

/// Animates the rotation of a widget around a pivot point.
class PivotTransition extends AnimatedWidget {
  /// Creates a rotation transition.
  ///
  /// The [turns] argument must not be null.
  PivotTransition({
    Key key,
    this.alignment: FractionalOffset.center,
    @required Animation<double> turns,
    this.child,
  }) : super(key: key, listenable: turns);

  /// The animation that controls the rotation of the child.
  ///
  /// If the current value of the turns animation is v, the child will be
  /// rotated v * 2 * pi radians before being painted.
  Animation<double> get turns => listenable;

  /// The pivot point to rotate around.
  final FractionalOffset alignment;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double turnsValue = turns.value;
    final Matrix4 transform = new Matrix4.rotationZ(turnsValue * math.PI * 2.0);
    return new Transform(
      transform: transform,
      alignment: alignment,
      child: child,
    );
  }
}