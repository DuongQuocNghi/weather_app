import 'package:weather_app/core/errors/exceptions.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/models/forecast_model.dart';

/// Interface định nghĩa các phương thức lấy dữ liệu thời tiết từ repository
abstract class WeatherRepository {
  /// Lấy thông tin thời tiết hiện tại tại vị trí có tọa độ [lat] và [lon]
  Future<WeatherModel> getCurrentWeather(double lat, double lon);

  /// Lấy dự báo thời tiết 5 ngày tại vị trí có tọa độ [lat] và [lon]
  ///   /// [cnt]: số lượng mốc thời gian cần lấy, mỗi mốc cách nhau 3 giờ
  Future<ForecastModel> getFiveDayForecast(double lat, double lon, {int? cnt});
}

/// Implementation của WeatherRepository
class DefaultWeatherRepository implements WeatherRepository {
  final WeatherService weatherService;

  DefaultWeatherRepository({required this.weatherService});

  @override
  Future<WeatherModel> getCurrentWeather(double lat, double lon) async {
    try {
      final jsonData = await weatherService.fetchCurrentWeather(lat, lon);
      return WeatherModel.fromJson(jsonData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ForecastModel> getFiveDayForecast(double lat, double lon, {int? cnt}) async {
    try {
      final jsonData = await weatherService.fetchFiveDayForecast(lat, lon, cnt: cnt);
      return ForecastModel.fromJson(jsonData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
