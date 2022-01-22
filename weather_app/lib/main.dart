import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/ui/home/home_page.dart';
import 'package:weather_app/ui/weather_viewmodel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key) {
    //Reading encrypted parameters works after starting the application itself and rendering the first frame.
    //Exception when try get geolocation.
    WidgetsFlutterBinding.ensureInitialized();
    model.getWeatherCurrentLocation();
  }

  final WeatherViewModel model = WeatherViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WeatherViewModel>.value(
      value: model,
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          // '/': (context) => const LoadingScreenWidget(),
          '/': (context) => const HomePage(),
        },
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
      ),
    );
  }
}
