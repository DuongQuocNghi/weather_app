import 'package:equatable/equatable.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/models/forecast_model.dart';

enum WeatherStatus { initial, loading, success, failure }

class WeatherState extends Equatable {
  final WeatherStatus status;
  final WeatherModel? weather;
  final ForecastModel? forecast;
  final String? errorMessage;

  const WeatherState({
    this.status = WeatherStatus.initial,
    this.weather,
    this.forecast,
    this.errorMessage,
  });

  WeatherState copyWith({
    WeatherStatus? status,
    WeatherModel? weather,
    ForecastModel? forecast,
    String? errorMessage,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      forecast: forecast ?? this.forecast,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, weather, forecast, errorMessage];
}
