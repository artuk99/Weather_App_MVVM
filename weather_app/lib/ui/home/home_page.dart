import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:weather_app/test/error_listener.dart';
import 'package:weather_app/ui/component/autocomplete_app_bar.dart';

import 'package:weather_app/ui/current_weather/current_weather_widget.dart';
import 'package:weather_app/ui/current_weather_gif/current_weather_gif_widget.dart';
import 'package:weather_app/ui/daily_weather/daily_weather_widget.dart';
import 'package:weather_app/ui/hourlu_weather_chart/hourly_weaher_chart_widget.dart';
import 'package:weather_app/ui/weather_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: const AutocompleteAppBar(),
          ),
          body: ErrorListener<WeatherViewModel>(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: const Body(),
            ),
          ),
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WeatherViewModel>(context);

    if (model.isFirstLoad) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 245, 239, 239),
              Color.fromARGB(255, 254, 173, 166),
            ],
          ),
        ),
      );
    }
    return SlidingUpPanel(
      color: Colors.transparent,
      minHeight: 50,
      header: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.only(top: 22),
          width: 150,
          height: 6,
          decoration: const BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
        ),
      ),
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      panel: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2.0,
            sigmaY: 2.0,
          ),
          child: Container(
            padding: const EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 1.2,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            child: const DailyWeatherWidget(),
          ),
        ),
      ),
      body: Container(
        color: Colors.pink.shade200,
        child: ListView(
          padding: const EdgeInsets.only(top: 0),
          children: const [
            CurrentWeatherGifWidget(),
            HourlyWeatherChartWidget(),
            SizedBox(height: 15),
            CurrentWeatherWidget(),
            SizedBox(height: 100)
          ],
        ),
      ),
    );
  }
}
