import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/app/config/app_config.dart';
import 'package:weather_app/app/di/injection_container.dart';
import 'package:weather_app/features/weather/bloc/weather_bloc.dart';
import 'package:weather_app/features/weather/bloc/weather_event.dart';
import 'package:weather_app/features/weather/bloc/weather_state.dart';
import 'package:weather_app/features/weather/widgets/weather_error.dart';
import 'package:weather_app/features/weather/widgets/weather_loading.dart';
import 'package:weather_app/features/weather/widgets/weather_info.dart';
import 'package:weather_app/features/weather/widgets/five_day_forecast.dart';
import 'package:weather_app/repositories/weather_repository.dart';
import 'package:weather_app/services/location_service.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => WeatherBloc(
            weatherRepository: sl<WeatherRepository>(),
            locationService: sl<LocationService>(),
          )..add(const WeatherFetched()),
      child: const WeatherView(),
    );
  }
}

class WeatherView extends StatelessWidget {
  const WeatherView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.background,
      body: SafeArea(
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            switch (state.status) {
              case WeatherStatus.initial:
                return const WeatherLoading();
              case WeatherStatus.loading:
                return const WeatherLoading();
              case WeatherStatus.success:
                if (state.weather == null) {
                  return const WeatherLoading();
                }
                return Column(
                  children: [
                    // Hiển thị thông tin thời tiết hiện tại
                    Expanded(
                      flex: 2,
                      child: WeatherInfo(weather: state.weather!),
                    ),

                    // Hiển thị dự báo 5 ngày nếu có dữ liệu
                    if (state.forecast != null)
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: FiveDayForecast(forecast: state.forecast!),
                        ),
                      ),
                  ],
                );
              case WeatherStatus.failure:
                return WeatherError(
                  errorMessage: state.errorMessage ?? 'Có lỗi xảy ra',
                  onRetry: () {
                    context.read<WeatherBloc>().add(const WeatherRefreshed());
                  },
                );
            }
          },
        ),
      ),
    );
  }
}
