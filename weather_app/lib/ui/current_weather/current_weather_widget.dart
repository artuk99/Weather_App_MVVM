import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/ui/weather_viewmodel.dart';

class CurrentWeatherWidget extends StatelessWidget {
  const CurrentWeatherWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WeatherViewModel>(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          color: Colors.white,
          padding:
              const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Image.asset('./assets/images/${model.currentIcon}',
                      height: 35, width: 35),
                  const SizedBox(width: 5),
                  Column(
                    children: [
                      Text(
                        model.currenTemp,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                model.currenWeatherDescription,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WeatherIndicator(
                        assetPath: 'humidity.png',
                        name: 'Humidity',
                        text: '${model.currentHumidity} %',
                      ),
                      const SizedBox(height: 8),
                      WeatherIndicator(
                        assetPath: 'cloudess.png',
                        name: 'Cloudiness',
                        text: '${model.currentCloudness} %',
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WeatherIndicator(
                        assetPath: 'uvi.png',
                        name: 'UV-index',
                        text: model.currentUvi,
                      ),
                      const SizedBox(height: 8),
                      WeatherIndicator(
                        assetPath: 'dewPoint.png',
                        name: 'Atmospheric\ntemperature',
                        text: '${model.curretnDewPoint} °C',
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WeatherIndicator(
                        assetPath: 'pressure.png',
                        name: 'Pressure',
                        text: '${model.currentPressure} hPa',
                      ),
                      const SizedBox(height: 8),
                      WeatherIndicator(
                        assetPath: 'visibility.png',
                        name: 'Average visibility',
                        text: '${model.currentVisibility} m',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherIndicator extends StatelessWidget {
  const WeatherIndicator(
      {Key? key,
      required this.assetPath,
      required this.text,
      required this.name})
      : super(key: key);

  final String assetPath;
  final String text;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('./assets/wind/$assetPath', height: 20, width: 20),
              const SizedBox(width: 5),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Text(
            name,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
