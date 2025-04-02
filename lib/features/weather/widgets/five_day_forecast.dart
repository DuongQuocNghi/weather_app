import 'package:flutter/material.dart';
import 'package:weather_app/app/config/app_config.dart';
import 'package:weather_app/app/config/font_config.dart';
import 'package:weather_app/src/models/forecast_model.dart';

class FiveDayForecast extends StatelessWidget {
  final ForecastModel forecast;

  const FiveDayForecast({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: forecast.forecastList.map((e) => _buildItem(e)).toList(),
      ),
    );
  }

  Widget _buildItem(ForecastItem e){
    return Column(
      children: [
        SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('data',
                style: FontConfig.body.copyWith(
                  color: appColors.onBackground_9,
                  height: 1.2
                ),
              ),
              Text('data',
                style: FontConfig.body.copyWith(
                    color: appColors.onBackground_9,
                    height: 1.2
                ),
              ),
            ],
          ),
        ),
        Container(height: 1, color: appColors.onBackground_3,)
      ],
    );
  }
}
