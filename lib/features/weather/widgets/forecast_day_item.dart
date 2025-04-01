import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/generated/i18n/app_localizations.dart';

class ForecastDayItem extends StatelessWidget {
  final DailyWeather dayWeather;

  const ForecastDayItem({Key? key, required this.dayWeather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatDay(dayWeather.dt),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Image.network(dayWeather.weather.iconUrl, width: 50, height: 50),
          const SizedBox(height: 12),
          Text(
            '${dayWeather.averageTempCelsius.round()}${AppLocalizations.of(context)?.temperature_celsius ?? '°C'}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            dayWeather.weather.main,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDay(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('EEE').format(date); // Thu, Fri, etc.
  }
}
