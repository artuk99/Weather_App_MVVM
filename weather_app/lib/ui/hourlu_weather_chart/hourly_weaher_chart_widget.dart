import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/ui/weather_viewmodel.dart';

class HourlyWeatherChartWidget extends StatelessWidget {
  const HourlyWeatherChartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Colors.pink[200];
    //final screenHeight = MediaQuery.of(context).size.height;
    //final ff = (screenHeight * 0.2 - 50 - 20) / 7 * 2 - 9 - 5;
    final model = Provider.of<WeatherViewModel>(context);
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 5),
            color: color,
            child: LineChart(mainData(model)),
            constraints: const BoxConstraints(minWidth: 1300, minHeight: 190),
            height: /*screenHeight * 0.2*/ 190,
            width: 1300,
          ),
          Container(
            color: color,
            margin: const EdgeInsetsDirectional.only(bottom: 20),
            width: 1300,
            child: Row(
              children: [
                const SizedBox(width: 1300 / 25 / 2),
                for (int i = 0; i < 24; i++)
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 1300 / 25,
                        child: model.hourlyWingDirection.isNotEmpty
                            ? Transform.rotate(
                                angle: model.hourlyWingDirection[i],
                                child: Image.asset(
                                  'assets/wind/wind_direction.png',
                                  width: 20,
                                  height: 20,
                                ),
                              )
                            : const Icon(Icons.error),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        model.hourlyWindSpeed[i],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 35,
                        width: 1300 / 25,
                        child: model.hourlyIcons.isNotEmpty
                            ? Image.asset(
                                'assets/images/' + model.hourlyIcons[i])
                            : const Icon(Icons.question_answer),
                      ),
                    ],
                  ),
                const SizedBox(width: 1300 / 25 / 2),
              ],
            ),
          ),
          //number under line
          Container(
            height: 90,
            color: Colors.white.withOpacity(0),
            margin: const EdgeInsetsDirectional.only(bottom: 100),
            width: 1300,
            child: Consumer<WeatherViewModel>(builder: (context, model, child) {
              return Row(
                children: [
                  const SizedBox(width: 1300 / 25 / 2),
                  for (int i = 1; i < 25; i++)
                    Container(
                      //(chart height - height.icon - height.titles)/(interval Y) * zavisitOt3 - text.fintSize - paddingLine
                      padding: EdgeInsets.only(
                          bottom: model.chartPaddings.isEmpty
                              ? 0
                              : model.chartPaddings[i] >= 0
                                  ? model.chartPaddings[i]
                                  : 0),
                      alignment: Alignment.bottomCenter,
                      width: 1300 / 25,
                      child: Text(
                        // '${model.chartData.values.isEmpty ? 0 : model.chartData.values.firstWhere((v) => v.x == i).y.toInt()}',
                        '${model.chartSpots.isEmpty ? 0 : model.chartSpots[i].y.toInt()}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  const SizedBox(width: 1300 / 25 / 2),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  LineChartData mainData(WeatherViewModel model) {
    List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xffe91e63),
    ];

    return LineChartData(
      backgroundColor: Colors.pink[200],
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
        drawHorizontalLine: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
          interval: 1,
          margin: 80,
          getTextStyles: (context, value) => TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            shadows: [
              Shadow(
                color: Colors.grey.shade600.withOpacity(1),
                offset: const Offset(1, 1),
                blurRadius: 1,
              )
            ],
            //height: 1,
          ),
          getTitles: (value) {
            // final time = DateTime.fromMillisecondsSinceEpoch(
            //     model.chartData.keys.firstWhere(
            //             (k) => model.chartData[k]?.x == value,
            //             orElse: () => 0) *
            //         1000,
            //     isUtc: true) /*times[value.toInt() - 1] * 1000)*/;
            return model.hourlyTitle[value.toInt()];
          },
        ),
        leftTitles: SideTitles(showTitles: false),
      ),
      minX: 0,
      maxX: 25,
      minY: (model.chartMinY - 3),
      maxY: model.chartMaxY,
      lineBarsData: [
        LineChartBarData(
          // spots: model.chartData.values.toList(),
          spots: model.chartSpots.toList(),
          isCurved: true,
          colors: //gradientColors,
              [Colors.white, Colors.white],
          barWidth: 1.6,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            gradientFrom: const Offset(0.5, 0),
            gradientTo: const Offset(0.5, 1),
            show: true,
            colors: [
              ColorTween(begin: Colors.white, end: gradientColors[1])
                  .lerp(0.1)!
                  .withOpacity(0.5),
              ColorTween(begin: Colors.white, end: gradientColors[1])
                  .lerp(0.5)!
                  .withOpacity(0.5),
            ],
          ),
        ),
      ],
    );
  }
}
