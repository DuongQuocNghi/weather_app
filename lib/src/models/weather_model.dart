import 'package:equatable/equatable.dart';

class WeatherModel extends Equatable {
  final CurrentWeather current;
  final List<DailyWeather> daily;
  final String timezone;
  final double lat;
  final double lon;

  const WeatherModel({
    required this.current,
    required this.daily,
    required this.timezone,
    required this.lat,
    required this.lon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      current: CurrentWeather.fromJson(json['current']),
      daily:
          (json['daily'] as List)
              .take(5) // Lấy ngày hiện tại và 4 ngày tiếp theo
              .map((daily) => DailyWeather.fromJson(daily))
              .toList(),
      timezone: json['timezone'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }

  String get locationName {
    return timezone.split('/').last.replaceAll('_', ' ');
  }

  @override
  List<Object?> get props => [current, daily, timezone, lat, lon];
}

class CurrentWeather extends Equatable {
  final double temp;
  final int dt;
  final Weather weather;

  const CurrentWeather({
    required this.temp,
    required this.dt,
    required this.weather,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temp: json['temp'].toDouble(),
      dt: json['dt'],
      weather: Weather.fromJson(json['weather'][0]),
    );
  }

  // Chuyển đổi từ Kelvin sang Celsius
  double get tempCelsius => temp - 273.15;

  @override
  List<Object?> get props => [temp, dt, weather];
}

class DailyWeather extends Equatable {
  final int dt;
  final TempRange temp;
  final Weather weather;

  const DailyWeather({
    required this.dt,
    required this.temp,
    required this.weather,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      dt: json['dt'],
      temp: TempRange.fromJson(json['temp']),
      weather: Weather.fromJson(json['weather'][0]),
    );
  }

  // Lấy nhiệt độ trung bình
  double get averageTemp => (temp.day + temp.night) / 2;

  // Chuyển đổi nhiệt độ trung bình từ Kelvin sang Celsius
  double get averageTempCelsius => averageTemp - 273.15;

  @override
  List<Object?> get props => [dt, temp, weather];
}

class TempRange extends Equatable {
  final double day;
  final double night;
  final double min;
  final double max;

  const TempRange({
    required this.day,
    required this.night,
    required this.min,
    required this.max,
  });

  factory TempRange.fromJson(Map<String, dynamic> json) {
    return TempRange(
      day: json['day'].toDouble(),
      night: json['night'].toDouble(),
      min: json['min'].toDouble(),
      max: json['max'].toDouble(),
    );
  }

  // Chuyển đổi các giá trị từ Kelvin sang Celsius
  double get dayCelsius => day - 273.15;
  double get nightCelsius => night - 273.15;
  double get minCelsius => min - 273.15;
  double get maxCelsius => max - 273.15;

  @override
  List<Object?> get props => [day, night, min, max];
}

class Weather extends Equatable {
  final int id;
  final String main;
  final String description;
  final String icon;

  const Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';

  @override
  List<Object?> get props => [id, main, description, icon];
}
