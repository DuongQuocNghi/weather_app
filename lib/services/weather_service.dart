import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/core/errors/exceptions.dart';

/// Interface định nghĩa các phương thức lấy dữ liệu thời tiết
abstract class WeatherService {
  /// Lấy dữ liệu thời tiết hiện tại tại vị trí có tọa độ [lat] và [lon]
  Future<Map<String, dynamic>> fetchCurrentWeather(double lat, double lon);

  /// Lấy dữ liệu dự báo 5 ngày tại vị trí có tọa độ [lat] và [lon]
  /// [cnt]: số lượng mốc thời gian cần lấy, mỗi mốc cách nhau 3 giờ
  Future<Map<String, dynamic>> fetchFiveDayForecast(double lat, double lon, {int? cnt});

  /// Lấy dữ liệu dự báo theo ngày [cnt] tại vị trí có tọa độ [lat] và [lon],
  Future<Map<String, dynamic>> fetchDailyForecast16Days(double lat, double lon, int cnt,);
}

/// Implementation của WeatherService sử dụng OpenWeatherMap API
class OpenWeatherMapService implements WeatherService {
  final http.Client client;
  final String? apiKey;
  final String? baseUrl;

  OpenWeatherMapService({required this.client})
    : apiKey = dotenv.env['OPENWEATHER_API_KEY'],
      baseUrl = dotenv.env['OPENWEATHER_BASE_URL'];

  /// Kiểm tra cấu hình API
  void _checkApiConfig() {
    if (apiKey == null || baseUrl == null) {
      throw const ServerException(message: 'API key or base URL not found');
    }
  }

  @override
  Future<Map<String, dynamic>> fetchCurrentWeather(
    double lat,
    double lon,
  ) async {
    _checkApiConfig();

    final url =
        '$baseUrl/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

    try {
      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ServerException(
          message: 'Server error with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> fetchFiveDayForecast(
    double lat,
    double lon,
      {int? cnt}
  ) async {
    _checkApiConfig();

    final url =
        '$baseUrl/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey${cnt != null ? '&cnt=$cnt' : ''}&units=metric';

    try {
      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ServerException(
          message: 'Server error with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }


  @override
  Future<Map<String, dynamic>> fetchDailyForecast16Days(
      double lat,
      double lon,
      int cnt,
      ) async {
    _checkApiConfig();

    final url =
        '$baseUrl/data/2.5/forecast/daily?lat=$lat&lon=$lon&cnt=$cnt&appid=$apiKey&units=metric';

    try {
      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ServerException(
          message: 'Server error with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
