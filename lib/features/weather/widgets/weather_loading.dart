import 'package:flutter/material.dart';
import 'package:weather_app/src/generated/i18n/app_localizations.dart';

class WeatherLoading extends StatelessWidget {
  const WeatherLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)?.loading_weather ??
                'Đang tải dữ liệu thời tiết...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
