import 'dart:math' as math;
import 'dart:async';
import 'dart:collection';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:weather_app/data/remote/open_weather_map_api.dart';
import 'package:weather_app/data/model/hourly_weather.dart';
import 'package:weather_app/services/connection.dart';
import 'package:weather_app/services/location.dart';
import 'package:weather_app/test/error_listener.dart';

// enum _WeatherViewModelStates {  }
//

class WeatherViewModel extends ChangeNotifier with ErrorNotifierMixin {
  String currenTemp = '';
  String currentIcon = '';
  String currenWeatherDescription = '';
  String currentCloudness = '';
  String currentPressure = '';
  String currentImageAsset = '';
  String currentUvi = '';
  String currentVisibility = '';
  String curretnDewPoint = '';
  String currentHumidity = '';

  List<String> hourlyTitle = [];
  List<String> hourlyIcons = [];
  List<double> hourlyWingDirection = [];
  List<String> hourlyWindSpeed = [];

  List<String> daysIcons = [];
  List<String> daysTemp = [];
  List<int> daysName = [];
  List<String> daysHumidity = [];
  List<String> daysPressure = [];
  List<String> daysCloudness = [];
  List<String> daysDewPoints = [];
  List<String> daysPrecipitation = [];
  List<String> daysUvi = [];
  List<int> daysWindDirection = [];
  List<String> daysWindSpeed = [];
  List<String> daysWeatherDescription = [];
  List<String> daysWindGust = [];

  final _connectionService = Connection();
  final _locationService = UserLocation();
  final _apiClient = OpenWeatherMapApiClient();

  double? _chartMaxY;
  double get chartMaxY => _chartMaxY ?? 0;
  double? _chartMinY;
  double get chartMinY => _chartMinY ?? 0;
  final List<FlSpot> _chartSpots = [];
  UnmodifiableListView<FlSpot> get chartSpots =>
      UnmodifiableListView<FlSpot>(_chartSpots);
  final List<double> _chartPaddings = [];
  UnmodifiableListView<double> get chartPaddings =>
      UnmodifiableListView<double>(_chartPaddings);

  bool isLoading = true;
  bool isFirstLoad = true;
  String _errorMessage = '';

  Future<void> _getHourlyWeather(
      {required double? lat, required double? lon}) async {
    final HourlyWeather response;

    response = await _apiClient.getWeather(lat: lat, lon: lon);

    _clear();

    currenTemp = response.current.temp.round().toString();
    currentIcon = response.current.weather.first.icon;
    currenWeatherDescription = response.current.weather.first.description;
    currentCloudness = response.current.clouds.toString();
    currentPressure = response.current.pressure.toString();
    currentImageAsset = _getImagePath(response.current.weather.first.icon);
    currentUvi = response.current.uvi.toString();
    currentVisibility = response.current.visibility.toString();
    curretnDewPoint = response.current.dewPoint.toString();
    currentHumidity = response.current.humidity.toString();

    _chartMinY = response.hourly[0].temp.roundToDouble();
    _chartMaxY = response.hourly[0].temp.roundToDouble();
    // _chartData[-1] = FlSpot(0, response.hourly[0].temp.roundToDouble());
    _chartSpots.add(FlSpot(0, response.hourly[0].temp.roundToDouble()));
    hourlyTitle.add('');

    for (var i in response.hourly) {
      if (_chartSpots.length < 25) {
        // _chartData[i.dt + response.timezoneOffset] =
        // FlSpot(_chartData.length.toDouble(), i.temp.roundToDouble());
        _chartSpots
            .add(FlSpot(_chartSpots.length.toDouble(), i.temp.roundToDouble()));

        final time = DateTime.fromMillisecondsSinceEpoch(
            (i.dt + response.timezoneOffset) * 1000,
            isUtc: true);
        final title = DateFormat.Hm().format(time).toString();
        hourlyTitle.add(title);
        hourlyIcons.add(i.weather.first.icon);
        if (_chartMaxY! < i.temp) _chartMaxY = i.temp;
        if (_chartMinY! > i.temp) _chartMinY = i.temp;

        final angle = (180 + i.windDeg) * math.pi / 180;
        hourlyWingDirection.add(angle);
        hourlyWindSpeed.add(i.windSpeed.toString());
      }
    }
    // _chartData[1] = FlSpot(25, response.hourly[23].temp.roundToDouble());
    _chartSpots.add(FlSpot(25, response.hourly[23].temp.roundToDouble()));
    hourlyTitle.add('');

    for (var i in _chartSpots) {
      final sizeOne = (85) / (_chartMaxY! - _chartMinY! + 3);
      final count = 2 + i.y - _chartMinY!;
      final padding = sizeOne * count - 15;
      _chartPaddings.add(padding);
    }

    for (var d in response.daily) {
      daysIcons.add(d.weather.first.icon);
      daysTemp.add(d.temp.day.round().toString());
      daysName.add(d.dt);
      daysHumidity.add(d.humidity.toString());
      daysPressure.add(d.pressure.toString());
      daysCloudness.add(d.clouds.toString());
      daysDewPoints.add(d.dewPoint.toString());
      daysPrecipitation.add((d.pop * 100).toInt().toString());
      daysUvi.add(d.uvi.toString());
      daysWindDirection.add(d.windDeg);
      daysWindSpeed.add(d.windSpeed.round().toString());
      daysWeatherDescription.add(d.weather.first.description);
    }
  }

  Future<void> getWeatherCurrentLocation() async {
    isLoading = true;
    notifyListeners();

    ConnectivityResult? result;
    try {
      result = await _connectionService.checkConnection();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
    if (result == ConnectivityResult.none) {
      _errorMessage = 'Check connection and try later.';
      notifyError(_errorMessage);
      // isFirstLoad = false;
      isLoading = false;
      notifyListeners();
      return;
    }

    LocationData? data;
    try {
      data = await _locationService.determinePosition();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
    if (data == null) {
      _errorMessage = 'Problem with location service.';
      notifyError(_errorMessage);
      // isFirstLoad = false;
      isLoading = false;
      notifyListeners();
      return;
    }

    await _getHourlyWeather(lat: data.latitude, lon: data.longitude);
    _errorMessage = '';
    isLoading = false;
    isFirstLoad = false;
    notifyListeners();
  }

  Future<void> getWeatherSearchtLocation(double lat, double lon) async {
    isLoading = true;
    notifyListeners();

    ConnectivityResult? result = await _connectionService.checkConnection();
    if (result == ConnectivityResult.none) {
      _errorMessage = 'Check connection and try later.';
      notifyError(_errorMessage);
      // isFirstLoad = false;
      isLoading = false;
      notifyListeners();
      return;
    }

    await _getHourlyWeather(lat: lat, lon: lon);
    _errorMessage = '';
    isLoading = false;
    isFirstLoad = false;
    notifyListeners();
  }

  String _getImagePath(String iconId) {
    final id = iconId.substring(0, 2);
    switch (id) {
      case '01':
        return 'clear_weather_sakura.gif';
      case '02':
        return 'clear_weather_sakura.gif';
      case '03':
        return 'clouds_weather.gif';
      case '04':
        return 'clouds_weather.gif';
      case '09':
        return 'rain_weather.gif';
      case '10':
        return 'rain_weather.gif';
      case '13':
        return 'snow_weather.gif';
      default:
        return 'clear_weather_sakura.gif';
    }
  }

  void _clear() {
    currenTemp = '';
    currentIcon = '';
    currenWeatherDescription = '';
    currentCloudness = '';
    currentPressure = '';
    currentImageAsset = '';
    currentUvi = '';
    currentVisibility = '';
    curretnDewPoint = '';
    currentHumidity = '';

    _chartSpots.clear();
    hourlyTitle.clear();
    _chartPaddings.clear();
    hourlyIcons.clear();
    hourlyWingDirection.clear();
    hourlyWindSpeed.clear();

    daysIcons.clear();
    daysTemp.clear();
    daysName.clear();
    daysHumidity.clear();
    daysPressure.clear();
    daysCloudness.clear();
    daysDewPoints.clear();
    daysPrecipitation.clear();
    daysUvi.clear();
    daysWindDirection.clear();
    daysWindSpeed.clear();
    daysWeatherDescription.clear();
    daysWindGust.clear();
  }
}
