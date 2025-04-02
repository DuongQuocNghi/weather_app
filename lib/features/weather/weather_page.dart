import 'dart:io';

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
        bottom: false,
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
                var isVisibleForecast = state.forecast != null;
                return SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            SizedBox(height: 56,),
                            // Hiển thị thông tin thời tiết hiện tại
                            WeatherInfo(weather: state.weather!),
                            // Container(height: 62, width: 200, color: Colors.red,),
                          ],
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 1300),
                        curve: Curves.easeInOut,
                        left: 0, right: 0,
                        bottom: isVisibleForecast ? 0 : -MediaQuery.of(context).size.height,
                        height: MediaQuery.of(context).size.height - (isVisibleForecast ? (Platform.isAndroid ? 307 : 342) : 0),
                        // Hiển thị dự báo 4 ngày nếu có dữ liệu
                        child: FiveDayForecast(forecast: state.forecast),
                      ),
                    ],
                  ),
                );
              case WeatherStatus.failure:
                return WeatherError(
                  errorMessage: state.errorMessage ?? 'Có lỗi xảy ra',
                  onRetry: () {
                    context.read<WeatherBloc>().add(const WeatherFetched());
                  },
                );
            }
          },
        ),
      ),
    );
  }
}
