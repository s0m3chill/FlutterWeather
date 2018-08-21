
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_weather/view/weather_widget.dart';
import 'package:flutter_weather/view/weather_card_widget.dart';
import 'package:flutter_weather/model/weather_data.dart';
import 'package:flutter_weather/model/forecast_data.dart';

void main() => runApp(new FlutterWeather());

class FlutterWeather extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new FlutterWeatherState();
  }

}

class FlutterWeatherState extends State<FlutterWeather> {

  WeatherData weatherData;
  ForecastData forecastData;
  bool isLoading = false;

  Location location = new Location();
  String locationError;

  String apiKey = 'd276ce21f21e137bff355f4639e2d02d';

  @override
  void initState() {
    super.initState();

    loadWeather();
  }

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
                            child: weatherData != null ? WeatherWidget(weather: weatherData) : Container(),
                          ),
                        ],
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 450.0,
                          child: forecastData != null ? ListView.builder(
                              itemCount: forecastData.list.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) =>
                                  WeatherCardWidget(weather: forecastData.list.elementAt(index))) : Container(),
                        ),
                      ),
                    )
                  ]
              )
          )
      ),
    );
  }

  loadWeather() async {
    setState(() {
      isLoading = true;
    });

//    Map<String, double> locationDict;
//
//    try {
//      locationDict = await location.getLocation();
//
//      locationError = null;
//    } on PlatformException catch (e) {
//      if (e.code == 'PERMISSION_DENIED') {
//        locationError = 'Permission denied';
//      }
//      else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
//        locationError = 'Permission denied - enable location';
//      }
//
//      locationDict = null;
//    }
//
//    double lat = locationDict != null ? locationDict['latitude'] : 51.508530;
//    double lon = locationDict != null ? locationDict['longitude'] : -0.076132;


    double lat =  51.508530;
    double lon =  -0.076132;


    final weatherResponse = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?APPID=${apiKey}&lat=${lat
            .toString()}&lon=${lon.toString()}&units=metric');
    final forecastResponse = await http.get(
        'https://api.openweathermap.org/data/2.5/forecast?APPID=${apiKey}&lat=${lat
            .toString()}&lon=${lon.toString()}&units=metric');

    if (weatherResponse.statusCode == 200 &&
        forecastResponse.statusCode == 200) {
      return setState(() {
        weatherData =
        new WeatherData.fromJson(jsonDecode(weatherResponse.body));
        forecastData =
          new ForecastData.fromJson(jsonDecode(forecastResponse.body));
        isLoading = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

}
