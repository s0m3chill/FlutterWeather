
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

  @override
  State<StatefulWidget> createState() {
    return new FlutterWeatherState();
  }

}

class FlutterWeatherState extends State<FlutterWeather> with SingleTickerProviderStateMixin {

  // MARK: - Properties
  WeatherData _weatherData;
  ForecastData _forecastData;
  bool _isLoading = false;

  Animation<double> _animation;
  AnimationController _animationController;

  Widget _appBarTitle;
  Widget _defaultAppBar = new Text("Flutter Weather", style: new TextStyle(color: Colors.white));
  Icon _actionIcon = new Icon(Icons.search, color: Colors.white);
  final TextEditingController _searchQuery = new TextEditingController();

  List<String> _list;
  bool _isSearching = false;
  bool _shouldClose = false;
  String _searchText = "";
  List<String> _searchList = List();
  CityCoordinate _selectedCity;

  // MARK: - Initialization
  @override
  void initState() {
    super.initState();

    _appBarTitle = _defaultAppBar;

    _loadWeather();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    _animation = Tween(begin: 0.0, end: 350.0).animate(_animationController)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    _animationController.forward();

    _list = cities;

    if (_shouldClose == true) {
      _isSearching = false;
      _searchText = "";
    }
    else {
      _shouldClose = false;
      _searchQuery.addListener(() {
        setState(() {
          _isSearching = true;
          _searchText = _searchQuery.text;
        });
      });
    }
  }

  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // MARK: - Setup
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_weater',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          backgroundColor: _isSearching && !_shouldClose ? Colors.white : Colors.grey,
          appBar: buildBar(context),
          body: _isLoading ? new Container(constraints: BoxConstraints.expand(), child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[CircularProgressIndicator()],)
          ) : _isSearching && !_shouldClose ?
          ListView.builder(
              itemCount: cities.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                if (_searchText.isEmpty) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          '${_list[position]}',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
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
                      ListTile(
                        title: Text(
                          '${_searchList[position]}',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
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
                            child: _weatherData != null ? WeatherWidget(weather: _weatherData) : Container(),
                          ),
                        ],
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: _animation.value,
                          child: _forecastData != null ? ListView.builder(
                              itemCount: _forecastData.list.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) =>
                                  WeatherCardWidget(weather: _forecastData.list.elementAt(index))) : Container(),
                        ),
                      ),
                    )
                  ]
              )
          )
      ),
    );
  }

  _loadWeather() async {
    setState(() {
      _isLoading = true;
    });

    DeviceLocationManager deviceLocationManager = DeviceLocationManager();

    deviceLocationManager.fetchDeviceLocation().then((dict) async {
      Map<String, double> locationDict = deviceLocationManager.locationDict;

      double lat = _selectedCity != null ? _selectedCity.latitude : locationDict != null ? locationDict['latitude'] : 48.864716;
      double lon = _selectedCity != null ? _selectedCity.longitude : locationDict != null ? locationDict['longitude'] : 2.349014;

      final weatherResponse = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?APPID=${WeatherApi.apiKey}&lat=${lat
              .toString()}&lon=${lon.toString()}&units=metric');
      final forecastResponse = await http.get(
          'https://api.openweathermap.org/data/2.5/forecast?APPID=${WeatherApi.apiKey}&lat=${lat
              .toString()}&lon=${lon.toString()}&units=metric');

      if (weatherResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        return setState(() {
          _weatherData =
          new WeatherData.fromJson(jsonDecode(weatherResponse.body));
          _forecastData =
          new ForecastData.fromJson(jsonDecode(forecastResponse.body));
          _isLoading = false;
        });
      }

      setState(() {
        _isLoading = false;
      });
    });
  }

  // MARK: - Actions
  void _onTapItem(BuildContext context, String name) {
    _selectedCity = cityCoordinates[name];

    _handleSearchEnd();
    _loadWeather();
  }

  // MARK: - SearchBar
  Widget buildBar(BuildContext context) {
    return new AppBar(
        centerTitle: true,
        title: _appBarTitle,
        actions: <Widget>[
          new IconButton(icon: _actionIcon, onPressed: () {
            setState(() {
              if (_actionIcon.icon == Icons.search) {
                _actionIcon = new Icon(Icons.close, color: Colors.white,);
                _appBarTitle = new TextField(
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
      _shouldClose = true;
      _actionIcon = new Icon(Icons.search, color: Colors.white);
      _appBarTitle = _defaultAppBar;
      _isSearching = false;
      _searchQuery.clear();
    });
  }

}
