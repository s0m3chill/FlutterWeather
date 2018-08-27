import 'dart:async';

import 'package:device_info/device_info.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class DeviceLocationManager {

  Map<String, double> locationDict;
  Location _location = new Location();
  String _locationError;

  Future<Map<String, double>> fetchDeviceLocation() async {
//    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//
//    IosDeviceInfo iOSInfo = await deviceInfo.iosInfo;
//    //AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//
//    bool isPhysicalDevice = iOSInfo.isPhysicalDevice;// || androidInfo.isPhysicalDevice;

      try {
        locationDict = await _location.getLocation().timeout(const Duration (seconds: 2), onTimeout : () => _onUnknownLocation());

        _locationError = null;
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          _locationError = 'Permission denied';
        }
        else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
          _locationError = 'Permission denied - enable location';
        }

        locationDict = null;
      }

      return locationDict;
  }

  Map<String, double> _onUnknownLocation() {
    return null;
  }

}