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

class CurrentWeatherData {
  String temp = '';
  String icon = '';
  String weatherDescription = '';
  String cloudness = '';
  String pressure = '';
  String imageAsset = '';
  String uvi = '';
  String visibility = '';
  String dewPoint = '';
  String humidity = '';
}

class HourlyWeatherData {
  final String title;
  final String? icons;
  final double? wingDirection;
  final String? windSpeed;

  HourlyWeatherData(
      {required this.title, this.icons, this.wingDirection, this.windSpeed});
}

class DaysWeatherData {
  final String icons;
  final String temp;
  final int name;
  final String humidity;
  final String pressure;
  final String cloudness;
  final String dewPoints;
  final String precipitation;
  final String uvi;
  final int windDirection;
  final String windSpeed;
  final String weatherDescription;

  DaysWeatherData(
      {required this.icons,
      required this.temp,
      required this.name,
      required this.humidity,
      required this.pressure,
      required this.cloudness,
      required this.dewPoints,
      required this.precipitation,
      required this.uvi,
      required this.windDirection,
      required this.windSpeed,
      required this.weatherDescription});
}

class WeatherViewModel extends ChangeNotifier with ErrorNotifierMixin {
  final currenWeather = CurrentWeatherData();
  final List<HourlyWeatherData> hourlyWeather = [];
  final List<DaysWeatherData> daysWeather = [];

  // List<String> hourlyTitle = [];
  // List<String> hourlyIcons = [];
  // List<double> hourlyWingDirection = [];
  // List<String> hourlyWindSpeed = [];

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
    _makeCurrentWeatherData(response);

    _chartMinY = response.hourly[0].temp.roundToDouble();
    _chartMaxY = response.hourly[0].temp.roundToDouble();
    // _chartData[-1] = FlSpot(0, response.hourly[0].temp.roundToDouble());
    _chartSpots.add(FlSpot(0, response.hourly[0].temp.roundToDouble()));
    hourlyWeather.add(HourlyWeatherData(title: ''));

    for (var i in response.hourly) {
      if (_chartSpots.length < 25) {
        hourlyWeather.add(_makeHourlyWeatherData(i, response.timezoneOffset));

        // _chartData[i.dt + response.timezoneOffset] =
        // FlSpot(_chartData.length.toDouble(), i.temp.roundToDouble());
        _chartSpots
            .add(FlSpot(_chartSpots.length.toDouble(), i.temp.roundToDouble()));
        if (_chartMaxY! < i.temp) _chartMaxY = i.temp;
        if (_chartMinY! > i.temp) _chartMinY = i.temp;
      }
    }
    // _chartData[1] = FlSpot(25, response.hourly[23].temp.roundToDouble());
    _chartSpots.add(FlSpot(25, response.hourly[23].temp.roundToDouble()));
    hourlyWeather.add(HourlyWeatherData(title: ''));

    for (var i in _chartSpots) {
      final sizeOne = (85) / (_chartMaxY! - _chartMinY! + 3);
      final count = 2 + i.y - _chartMinY!;
      final padding = sizeOne * count - 15;
      _chartPaddings.add(padding);
    }

    for (var d in response.daily) {
      daysWeather.add(_makeDaysWeatherData(d));
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

  void _makeCurrentWeatherData(HourlyWeather weather) {
    currenWeather.cloudness = weather.current.clouds.toString();
    currenWeather.temp = weather.current.temp.round().toString();
    currenWeather.humidity = weather.current.humidity.toString();
    currenWeather.icon = weather.current.weather.first.icon;
    currenWeather.imageAsset =
        _getImagePath(weather.current.weather.first.icon);
    currenWeather.pressure = weather.current.pressure.toString();
    currenWeather.uvi = weather.current.uvi.toString();
    currenWeather.visibility = weather.current.visibility.toString();
    currenWeather.weatherDescription =
        weather.current.weather.first.description;
    currenWeather.dewPoint = weather.current.dewPoint.toString();
  }

  DaysWeatherData _makeDaysWeatherData(Daily weather) {
    return DaysWeatherData(
        cloudness: weather.clouds.toString(),
        dewPoints: weather.dewPoint.toString(),
        humidity: weather.humidity.toString(),
        icons: weather.weather.first.icon,
        name: weather.dt,
        precipitation: (weather.pop * 100).toInt().toString(),
        pressure: weather.pressure.toString(),
        temp: weather.temp.day.round().toString(),
        uvi: weather.uvi.toString(),
        weatherDescription: weather.weather.first.description,
        windDirection: weather.windDeg,
        windSpeed: weather.windSpeed.round().toString());
  }

  HourlyWeatherData _makeHourlyWeatherData(Current weather, int timezone) {
    final time = DateTime.fromMillisecondsSinceEpoch(
        (weather.dt + timezone) * 1000,
        isUtc: true);
    final title = DateFormat.Hm().format(time).toString();
    final angle = (180 + weather.windDeg) * math.pi / 180;
    return HourlyWeatherData(
        icons: weather.weather.first.icon,
        title: title,
        windSpeed: weather.windSpeed.toString(),
        wingDirection: angle);
  }

  void _clear() {
    _chartSpots.clear();
    _chartPaddings.clear();
  }
}
