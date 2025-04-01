import 'package:weather_app/core/errors/exceptions.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/models/forecast_model.dart';

class WeatherRepository {
  final WeatherService weatherService;

  WeatherRepository({required this.weatherService});

  Future<WeatherModel> getCurrentWeather(double lat, double lon) async {
    try {
      final jsonData = await weatherService.fetchCurrentWeather(lat, lon);

      // Chuyển đổi dữ liệu từ API /weather sang định dạng tương thích với model
      final Map<String, dynamic> formattedData = {
        'lat': jsonData['coord']['lat'],
        'lon': jsonData['coord']['lon'],
        'timezone': jsonData['name'] ?? 'Unknown',
        'current': {
          'temp': jsonData['main']['temp'],
          'dt': jsonData['dt'],
          'weather': jsonData['weather'],
        },
        'daily': [
          {
            'dt': jsonData['dt'],
            'temp': {
              'day': jsonData['main']['temp'],
              'night': jsonData['main']['temp'],
              'min': jsonData['main']['temp_min'],
              'max': jsonData['main']['temp_max'],
            },
            'weather': jsonData['weather'],
          },
        ],
      };

      return WeatherModel.fromJson(formattedData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<ForecastModel> getFiveDayForecast(double lat, double lon) async {
    try {
      final jsonData = await weatherService.fetchFiveDayForecast(lat, lon);
      return ForecastModel.fromJson(jsonData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
