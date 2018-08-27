import 'dart:async';

import 'package:device_info/device_info.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class DeviceLocationManager {

  Map<String, double> locationDict;
  Location _location = new Location();
  String _locationError;

  Future<Map<String, double>> fetchDeviceLocation() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    IosDeviceInfo iOSInfo = await deviceInfo.iosInfo;
    //AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    bool isPhysicalDevice = iOSInfo.isPhysicalDevice;// || androidInfo.isPhysicalDevice;

    if (isPhysicalDevice) {
      try {
        locationDict = await _location.getLocation();

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

    return null;
  }

}