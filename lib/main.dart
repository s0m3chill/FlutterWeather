
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_weather/utils/device_location_manager.dart';
import 'package:flutter_weather/view/weather_widget.dart';
import 'package:flutter_weather/view/weather_card_widget.dart';
import 'package:flutter_weather/model/weather_data.dart';
import 'package:flutter_weather/model/forecast_data.dart';
import 'package:flutter_weather/model/city_coordinate.dart';
import 'package:flutter_weather/model/city_datasource.dart';

void main() => runApp(new FlutterWeather());

class FlutterWeather extends StatefulWidget {

  FlutterWeather({ Key key }) : super(key: key);

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

  //
  Widget appBarTitle;
  Widget _defaultAppBar = new Text("Flutter Weather", style: new TextStyle(color: Colors.white));
  Icon actionIcon = new Icon(Icons.search, color: Colors.white);
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  List<String> _list;
  bool _isSearching = false;
  bool _shouldClose = false;
  String _searchText = "";

  List<String> _searchList = List();

  CityCoordinate selectedCity = null;


  @override
  void initState() {
    super.initState();

    appBarTitle = _defaultAppBar;

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

    _list = cities;

    if (this._shouldClose == true) {
      _isSearching = false;
      _searchText = "";
    }
    else {
      this._shouldClose = false;
      _searchQuery.addListener(() {
        setState(() {
          _isSearching = true;
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
          body: _isSearching && !_shouldClose ?
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
    selectedCity = cityCoordinates[name];

    _handleSearchEnd();
    loadWeather();
  }

  loadWeather() async {
    setState(() {
      isLoading = true;
    });

    DeviceLocationManager deviceLocationManager = DeviceLocationManager();

    deviceLocationManager.fetchDeviceLocation().then((dict) async {
      Map<String, double> locationDict = deviceLocationManager.locationDict;

      double lat = selectedCity != null ? selectedCity.latitude : locationDict != null ? locationDict['latitude'] : 48.864716;
      double lon = selectedCity != null ? selectedCity.longitude : locationDict != null ? locationDict['longitude'] : 2.349014;

      final weatherResponse = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?APPID=${WeatherApi.apiKey}&lat=${lat
              .toString()}&lon=${lon.toString()}&units=metric');
      final forecastResponse = await http.get(
          'https://api.openweathermap.org/data/2.5/forecast?APPID=${WeatherApi.apiKey}&lat=${lat
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
    });
  }

  // MARK: - SearchBar

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

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this._shouldClose = true;
      this.actionIcon = new Icon(Icons.search, color: Colors.white);
      this.appBarTitle = _defaultAppBar;
      _isSearching = false;
      _searchQuery.clear();
    });
  }

}
