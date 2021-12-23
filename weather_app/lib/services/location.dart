import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as pemission;

class UserLocation {
  Future<LocationData?> determinePosition() async {
    Location location = Location();
    // location.enableBackgroundMode(enable: true);

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.deniedForever) {
      pemission.openAppSettings();
    }
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }
}
