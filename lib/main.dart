
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter/animation.dart';

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

class FlutterWeatherState extends State<FlutterWeather> with SingleTickerProviderStateMixin {

  WeatherData weatherData;
  ForecastData forecastData;
  bool isLoading = false;

  Animation<double> animation;
  AnimationController controller;

  Location location = new Location();
  String locationError;

  String apiKey = 'd276ce21f21e137bff355f4639e2d02d';

  @override
  void initState() {
    super.initState();

    loadWeather();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 450.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    controller.forward();
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_weater',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            title: Text('Weather'),
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
                          height: animation.value,
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

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    IosDeviceInfo iOSInfo = await deviceInfo.iosInfo;
    //AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    bool isPhysicalDevice = iOSInfo.isPhysicalDevice;// || androidInfo.isPhysicalDevice;

    Map<String, double> locationDict;

    if (isPhysicalDevice) {
      try {
        locationDict = await location.getLocation();

        locationError = null;
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          locationError = 'Permission denied';
        }
        else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
          locationError = 'Permission denied - enable location';
        }

        locationDict = null;
      }
    }

    double lat = locationDict != null ? locationDict['latitude'] : 51.508530;
    double lon = locationDict != null ? locationDict['longitude'] : -0.076132;

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
