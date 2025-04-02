import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/app/config/app_config.dart';
import 'package:weather_app/app/config/font_config.dart';
import 'package:weather_app/src/models/forecast_model.dart';

class FiveDayForecast extends StatelessWidget {
  final ForecastModel? forecast;

  const FiveDayForecast({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return forecast?.list == null ? SizedBox() : Container(
      decoration: BoxDecoration(
        color: appColors.surface,
        boxShadow: [
          BoxShadow(
            color: appColors.onBackground_3,
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: ListView.builder(
          itemCount: forecast?.list?.length,
            itemBuilder: (context, index) => _buildItem(forecast?.list?[index])),
      ),
    );
  }

  Widget _buildItem(ForecastItem? e){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(e?.dt == null ? '' : DateFormat('EEEE').format(e!.dt!),
                  style: FontConfig.body.copyWith(
                    color: appColors.onBackground_9,
                    height: 1.2
                  ),
                ),
                Text('${(e?.temp?.day ?? e?.main?.temp)?.toString() ?? ''} C',
                  style: FontConfig.body.copyWith(
                      color: appColors.onBackground_9,
                      height: 1.2
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: appColors.onBackground_2,)
        ],
      ),
    );
  }
}
