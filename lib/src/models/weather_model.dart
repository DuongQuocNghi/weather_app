import 'package:equatable/equatable.dart';

class WeatherModel {
  final CurrentWeather? main;
  final String? name;

  const WeatherModel({
    this.main,
    this.name,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
        main: CurrentWeather.fromJson(json['main']),
        name: json['name']
    );
  }

}

class CurrentWeather {
  final double? temp;

  const CurrentWeather({
    this.temp,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temp: json['temp']?.toDouble(),
    );
  }
}