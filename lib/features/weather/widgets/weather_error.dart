import 'package:flutter/material.dart';
import 'package:weather_app/app/config/app_config.dart';
import 'package:weather_app/core/widgets/button.dart';
import 'package:weather_app/src/generated/i18n/app_localizations.dart';
import 'package:weather_app/app/config/font_config.dart';

class WeatherError extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const WeatherError({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appColors.red_3,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)?.error_loading_weather ??
                    'Không thể tải dữ liệu thời tiết',
                style: FontConfig.h2.copyWith(
                  color: appColors.onPrimaryLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 44),
              AppButton(
                height: null,
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                onPressed: onRetry,
                title: AppLocalizations.of(context)?.retry ?? 'Thử lại',
                backroundColor: appColors.onBackground_8,
                titleStyle: FontConfig.body.copyWith(color: appColors.surface),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
