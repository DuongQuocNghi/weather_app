import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/app/config/app_config.dart';
import 'package:weather_app/app/config/font_config.dart';
import 'package:weather_app/features/weather/widgets/forecast_day_item.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/generated/i18n/app_localizations.dart';

class WeatherInfo extends StatelessWidget {
  final WeatherModel weather;

  const WeatherInfo({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCurrentWeather(context),
        _buildLocationInfo(),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Text(
      weather.locationName,
      style: FontConfig.h3.copyWith(
        color: appColors.blue_3,
        height: 1.4
      ),
    );
  }

  Widget _buildCurrentWeather(BuildContext context) {
    return Text(
      '${weather.current.tempCelsius.round()}${AppLocalizations.of(context)?.temperature ?? '°'}',
      style: FontConfig.h1.copyWith(
        color: appColors.onBackground_9,
        height: 1.2
      ),
    );
  }
}
