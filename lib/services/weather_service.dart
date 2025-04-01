import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/core/errors/exceptions.dart';

class WeatherService {
  final http.Client client;
  final String? apiKey;
  final String? baseUrl;

  WeatherService({required this.client})
    : apiKey = dotenv.env['OPENWEATHER_API_KEY'],
      baseUrl = dotenv.env['OPENWEATHER_BASE_URL'];

  /// Kiểm tra cấu hình API
  void _checkApiConfig() {
    if (apiKey == null || baseUrl == null) {
      throw const ServerException(message: 'API key or base URL not found');
    }
  }

  /// Lấy dữ liệu thời tiết hiện tại
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

  /// Lấy dữ liệu dự báo 5 ngày
  Future<Map<String, dynamic>> fetchFiveDayForecast(
    double lat,
    double lon,
  ) async {
    _checkApiConfig();

    final url =
        '$baseUrl/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

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
