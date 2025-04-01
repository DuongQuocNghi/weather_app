import 'package:equatable/equatable.dart';

class ForecastModel extends Equatable {
  final String cityName;
  final List<ForecastItem> forecastList;
  final double lat;
  final double lon;

  const ForecastModel({
    required this.cityName,
    required this.forecastList,
    required this.lat,
    required this.lon,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      cityName: json['city']['name'],
      lat: json['city']['coord']['lat'],
      lon: json['city']['coord']['lon'],
      forecastList:
          (json['list'] as List)
              .map((item) => ForecastItem.fromJson(item))
              .toList(),
    );
  }

  @override
  List<Object?> get props => [cityName, forecastList, lat, lon];
}

class ForecastItem extends Equatable {
  final int dt;
  final MainWeather main;
  final List<WeatherInfo> weather;
  final Wind wind;
  final int visibility;
  final Cloud clouds;
  final String dtTxt;

  const ForecastItem({
    required this.dt,
    required this.main,
    required this.weather,
    required this.wind,
    required this.visibility,
    required this.clouds,
    required this.dtTxt,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dt: json['dt'],
      main: MainWeather.fromJson(json['main']),
      weather:
          (json['weather'] as List)
              .map((item) => WeatherInfo.fromJson(item))
              .toList(),
      wind: Wind.fromJson(json['wind']),
      visibility: json['visibility'],
      clouds: Cloud.fromJson(json['clouds']),
      dtTxt: json['dt_txt'],
    );
  }

  @override
  List<Object?> get props => [
    dt,
    main,
    weather,
    wind,
    visibility,
    clouds,
    dtTxt,
  ];
}

class MainWeather extends Equatable {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final double? seaLevel;
  final double? groundLevel;

  const MainWeather({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    this.seaLevel,
    this.groundLevel,
  });

  factory MainWeather.fromJson(Map<String, dynamic> json) {
    return MainWeather(
      temp: json['temp'].toDouble(),
      feelsLike: json['feels_like'].toDouble(),
      tempMin: json['temp_min'].toDouble(),
      tempMax: json['temp_max'].toDouble(),
      pressure: json['pressure'],
      humidity: json['humidity'],
      seaLevel: json['sea_level']?.toDouble(),
      groundLevel: json['grnd_level']?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [
    temp,
    feelsLike,
    tempMin,
    tempMax,
    pressure,
    humidity,
    seaLevel,
    groundLevel,
  ];
}

class WeatherInfo extends Equatable {
  final int id;
  final String main;
  final String description;
  final String icon;

  const WeatherInfo({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
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

class Wind extends Equatable {
  final double speed;
  final int deg;
  final double? gust;

  const Wind({required this.speed, required this.deg, this.gust});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json['speed'].toDouble(),
      deg: json['deg'],
      gust: json['gust']?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [speed, deg, gust];
}

class Cloud extends Equatable {
  final int all;

  const Cloud({required this.all});

  factory Cloud.fromJson(Map<String, dynamic> json) {
    return Cloud(all: json['all']);
  }

  @override
  List<Object?> get props => [all];
}
