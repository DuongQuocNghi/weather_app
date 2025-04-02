import 'package:weather_app/src/models/weather_model.dart';

class ForecastModel {
  final List<ForecastItem>? list;

  const ForecastModel({
    this.list,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      list: json['list'] == null ? null : (json['list'] as List).map((item) => ForecastItem.fromJson(item)).toList(),
    );
  }
}

class ForecastItem {
  final DayTemp? temp;
  final MainWeather? main;
  final DateTime? dt;

  const ForecastItem({
    this.dt,
    this.temp,
    this.main,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dt: json['dt'] == null ? null : DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      temp: json['temp'] == null ? null : DayTemp.fromJson(json['temp']),
      main: json['main'] == null ? null : MainWeather.fromJson(json['main']),
    );
  }
}


class DayTemp {
  final double? day;

  const DayTemp({
    this.day,
  });

  factory DayTemp.fromJson(Map<String, dynamic> json) {
    return DayTemp(
      day: json['day']?.toDouble(),
    );
  }
}

