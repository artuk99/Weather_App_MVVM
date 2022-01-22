import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/ui/weather_viewmodel.dart';

class DailyWeatherWidget extends StatelessWidget {
  const DailyWeatherWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        for (int i = 0; i < 6; i++) DayWidget(i: i),
      ],
    );
  }
}

class DayWidget extends StatefulWidget {
  const DayWidget({required this.i, Key? key}) : super(key: key);

  final int i;

  @override
  _DayWidget createState() => _DayWidget();
}

class _DayWidget extends State<DayWidget> {
  bool _isDetail = false;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WeatherViewModel>(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          _isDetail = !_isDetail;
        });
      },
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        crossFadeState:
            _isDetail ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
          return topChild;
        },
        firstChild: Container(
          margin: const EdgeInsets.only(right: 5, left: 5, bottom: 5),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 3,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.EEEE().format(DateTime.fromMillisecondsSinceEpoch(model.daysWeather[widget.i].name * 1000)),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      DateFormat.Md().format(DateTime.fromMillisecondsSinceEpoch(model.daysWeather[widget.i].name * 1000)),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/${model.daysWeather[widget.i].icons}',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${model.daysWeather[widget.i].temp}°C',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    model.daysWeather[widget.i].weatherDescription,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
        secondChild: Container(
          margin: const EdgeInsets.only(right: 5, left: 5, bottom: 5),
          padding:
              const EdgeInsets.only(top: 15, right: 15, left: 15, bottom: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 3,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.EEEE().format(DateTime.fromMillisecondsSinceEpoch(model.daysWeather[widget.i].name * 1000)),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    DateFormat.Md().format(DateTime.fromMillisecondsSinceEpoch(model.daysWeather[widget.i].name * 1000)),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset(
                          './assets/images/${model.daysWeather[widget.i].icons}',
                          height: 30,
                          width: 30),
                      const SizedBox(width: 5),
                      Text(
                        '${model.daysWeather[widget.i].temp}°C',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    model.daysWeather[widget.i].weatherDescription,
                    style: TextStyle(
                      color: Colors.grey.shade600,
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
                            text: '${model.daysWeather[widget.i].humidity} %',
                          ),
                          const SizedBox(height: 8),
                          WeatherIndicator(
                            assetPath: 'cloudess.png',
                            name: 'Cloudiness',
                            text: '${model.daysWeather[widget.i].cloudness} %',
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WeatherIndicator(
                            assetPath: 'uvi.png',
                            name: 'UV-index',
                            text: model.daysWeather[widget.i].uvi,
                          ),
                          const SizedBox(height: 8),
                          WeatherIndicator(
                            assetPath: 'dewPoint.png',
                            name: 'Atmospheric\ntemperature',
                            text: '${model.daysWeather[widget.i].dewPoints} °C',
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WeatherIndicator(
                            assetPath: 'pressure.png',
                            name: 'Pressure',
                            text: '${model.daysWeather[widget.i].pressure} hPa',
                          ),
                          const SizedBox(height: 8),
                          WeatherIndicator(
                            assetPath: 'precipitation.png',
                            name: 'Probability of\nprecipitation',
                            text: '${model.daysWeather[widget.i].precipitation} %',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.arrow_drop_up, color: Colors.grey),
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
                  fontSize: 12,
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
