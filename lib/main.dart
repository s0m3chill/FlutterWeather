
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

class FlutterWeatherState extends State<FlutterWeather> with SingleTickerProviderStateMixin {

  WeatherData weatherData;
  ForecastData forecastData;
  bool isLoading = false;

  Animation<double> animation;
  AnimationController controller;

  Location location = new Location();
  String locationError;

  //
  Widget appBarTitle = new Text("Search Sample", style: new TextStyle(color: Colors.white),);
  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  List<String> _list;
  bool _IsSearching = false;
  bool _shouldClose = false;
  String _searchText = "";
  //

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
    _list.add("Google");
    _list.add("IOS");
    _list.add("Andorid");
    _list.add("Dart");
    _list.add("Flutter");
    _list.add("Python");
    _list.add("React");
    _list.add("Xamarin");
    _list.add("Kotlin");
    _list.add("Java");
    _list.add("RxAndroid");

    if (this._shouldClose == true) {
      _IsSearching = false;
      //_shouldClose = false;
      _searchText = "";
    }
    else {
      this._shouldClose = false;
      _searchQuery.addListener(() {
//      if (_searchQuery.text.isEmpty) {
//        setState(() {
//          _IsSearching = false;
//          _searchText = "";
//        });
//      }
//      else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
        //    }
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
          body: _IsSearching && !_shouldClose ? new ListView(
            padding: new EdgeInsets.symmetric(vertical: 8.0),
            children: _buildSearchList(),
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


  // List actions
  List<ListChildItem> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _list.map((contact) => new ListChildItem(contact))
          .toList();
    }
    else {
      List<String> _searchList = List();
      for (int i = 0; i < _list.length; i++) {
        String  name = _list.elementAt(i);
        if (name.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(name);
        }
      }
      return _searchList.map((contact) => new ListChildItem(contact))
          .toList();
    }
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
      new Text("Search Sample", style: new TextStyle(color: Colors.white),);
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

}
