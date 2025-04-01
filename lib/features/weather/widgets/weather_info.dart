import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/features/weather/widgets/forecast_day_item.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/generated/i18n/app_localizations.dart';

class WeatherInfo extends StatelessWidget {
  final WeatherModel weather;

  const WeatherInfo({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationInfo(),
            const SizedBox(height: 32),
            _buildCurrentWeather(context),
            const SizedBox(height: 32),
            _buildForecastTitle(context),
            const SizedBox(height: 16),
            _buildForecast(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          weather.locationName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          DateFormat('EEEE, d MMMM').format(DateTime.now()),
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withAlpha((0.5 * 255).toInt()),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentWeather(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${weather.current.tempCelsius.round()}${AppLocalizations.of(context)?.temperature_celsius ?? '°C'}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              weather.current.weather.description,
              style: TextStyle(
                color: Colors.white.withAlpha((0.5 * 255).toInt()),
                fontSize: 16,
              ),
            ),
          ],
        ),
        Image.network(
          weather.current.weather.iconUrl,
          width: 100,
          height: 100,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  Widget _buildForecastTitle(BuildContext context) {
    return Text(
      AppLocalizations.of(context)?.forecast_days ?? 'Dự báo 4 ngày tới',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildForecast() {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weather.daily.length - 1, // Trừ ngày hiện tại
        itemBuilder: (context, index) {
          // Bỏ qua ngày hiện tại, lấy 4 ngày tiếp theo
          final dailyWeather = weather.daily[index + 1];

          return ForecastDayItem(dayWeather: dailyWeather);
        },
      ),
    );
  }
}
