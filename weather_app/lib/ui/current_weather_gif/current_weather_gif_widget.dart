import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/ui/component/custom_line_widget.dart';
import 'package:weather_app/ui/weather_viewmodel.dart';

class CurrentWeatherGifWidget extends StatelessWidget {
  const CurrentWeatherGifWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WeatherViewModel>(context);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          // if chart over image
          // margin = reservedSize + ((chart height - reservedSize) / maxY)
          //margin: const EdgeInsetsDirectional.only(bottom: 110),
          width: MediaQuery.of(context).size.width,
          child: Image.asset('./assets/gifs/${model.currentImageAsset}',
              fit: BoxFit.fill),
        ),
        const CustomLineWidget(),
      ],
    );
  }
}

