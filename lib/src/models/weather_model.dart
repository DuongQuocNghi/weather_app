class WeatherModel {
  final MainWeather? main;
  final String? name;

  const WeatherModel({
    this.main,
    this.name,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
        main: MainWeather.fromJson(json['main']),
        name: json['name']
    );
  }

}

class MainWeather {
  final double? temp;

  const MainWeather({
    this.temp,
  });

  factory MainWeather.fromJson(Map<String, dynamic> json) {
    return MainWeather(
      temp: json['temp']?.toDouble(),
    );
  }
}