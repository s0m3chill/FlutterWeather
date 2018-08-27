
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
import 'package:flutter_weather/view/list_child_item.dart';

void main() => runApp(new FlutterWeather());

class FlutterWeather extends StatefulWidget {

  FlutterWeather({ Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new FlutterWeatherState();
  }

}

class CityCoordinate {

  final double latitude;
  final double longitude;

  CityCoordinate({this.latitude, this.longitude});

}

class FlutterWeatherState extends State<FlutterWeather> with SingleTickerProviderStateMixin {

  WeatherData weatherData;
  ForecastData forecastData;
  bool isLoading = false;

  Animation<double> animation;
  AnimationController controller;

  Location location = new Location();
  String locationError;

  //
  Widget appBarTitle = new Text("Flutter Weather", style: new TextStyle(color: Colors.white),);
  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  List<String> _list;
  bool _IsSearching = false;
  bool _shouldClose = false;
  String _searchText = "";


  Map<String, CityCoordinate> cities = {"Lviv": CityCoordinate(latitude: 49.8383, longitude: 24.0232),
                                        "Kyiv": CityCoordinate(latitude: 50.4547, longitude: 30.5238),
                                        "London": CityCoordinate(latitude: 51.509865, longitude: -0.118092)};

  List<String> _searchList = List();
  int searchCount = 0;


  CityCoordinate selectedCity = null;

  String apiKey = 'd276ce21f21e137bff355f4639e2d02d';

  @override
  void initState() {
    super.initState();

    loadWeather();
    controller = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    animation = Tween(begin: 0.0, end: 350.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    controller.forward();

    _list = List();
    _list.add("Lviv");
    _list.add("Kyiv");
    _list.add("London");

    if (this._shouldClose == true) {
      _IsSearching = false;
      _searchText = "";
    }
    else {
      this._shouldClose = false;
      _searchQuery.addListener(() {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      });
    }
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
          appBar: buildBar(context),
          body: _IsSearching && !_shouldClose ?
          ListView.builder(
              itemCount: 3,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                if (_searchText.isEmpty) {
                  return Column(
                    children: <Widget>[
                      Divider(height: 5.0),

                      ListTile(
                        title: Text(
                          '${_list[position]}',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        onTap: () => _onTapItem(context, '${_list[position]}'),
                      ),
                    ],
                  );
                }
                else {
                  _searchList = [];
                  for (int i = 0; i < _list.length; i++) {
                    String  name = _list.elementAt(i);
                    if (name.toLowerCase().contains(_searchText.toLowerCase())) {
                      _searchList.add(name);
                    } else {
                      _searchList.add("");
                    }
                  }

                  _searchList.sort((a, b) {
                    return b.compareTo(a);
                  });

                  searchCount = _searchList.length;

                  return Column(
                    children: <Widget>[
                      Divider(height: 5.0),

                      ListTile(
                        title: Text(
                          '${_searchList[position]}',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        onTap: () => _onTapItem(context, '${_searchList[position]}'),
                      ),
                    ],
                  );
                }
              }
      ) : Center(
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

  void _onTapItem(BuildContext context, String name) {
    selectedCity = cities[name];

    _handleSearchEnd();
    loadWeather();
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

    double lat = locationDict != null ? locationDict['latitude'] : selectedCity != null ? selectedCity.latitude : 48.864716;
    double lon = locationDict != null ? locationDict['longitude'] : selectedCity != null ? selectedCity.longitude : 2.349014;

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

  // SearchBar

  Widget buildBar(BuildContext context) {
    return new AppBar(
        centerTitle: true,
        title: appBarTitle,
        actions: <Widget>[
          new IconButton(icon: actionIcon, onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close, color: Colors.white,);
                this.appBarTitle = new TextField(
                  controller: _searchQuery,
                  style: new TextStyle(
                    color: Colors.white,

                  ),
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.white)
                  ),
                );
                _handleSearchStart();
              }
              else {
                _handleSearchEnd();
              }
            });
          },),
        ]
    );
  }

  // Actions

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this._shouldClose = true;
      this.actionIcon = new Icon(Icons.search, color: Colors.white,);
      this.appBarTitle =
      new Text("Flutter Weater", style: new TextStyle(color: Colors.white),);
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

}
