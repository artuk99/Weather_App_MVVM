import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/data/model/hourly_weather.dart';

class OpenWeatherMapApiClient {
  final client = http.Client();
  static const url = 'api.openweathermap.org';
  static const path = 'data/2.5/onecall';

  final queryParametrs = {
    'lat': '',
    'lon': '',
    'exclude': 'minutely,alerts',
    'units': 'metric',
    'appid': '98c1dfb50c2e7d902b77e69667bbf1c1'
  };

  Future<HourlyWeather> getWeather(
      {required double? lat, required double? lon}) async {
    queryParametrs['lat'] = lat.toString();
    queryParametrs['lon'] = lon.toString();

    final response = await client.get(Uri.https(url, path, queryParametrs));
    
    if (response.statusCode == 200) {
      return HourlyWeather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
