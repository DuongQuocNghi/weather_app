import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/exceptions.dart';
import 'package:weather_app/repositories/weather_repository.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/models/forecast_model.dart';

class MockWeatherService extends Mock implements WeatherService {}

void main() {
  late DefaultWeatherRepository repository;
  late MockWeatherService mockWeatherService;

  setUp(() {
    mockWeatherService = MockWeatherService();
    repository = DefaultWeatherRepository(weatherService: mockWeatherService);
  });

  group('getCurrentWeather', () {
    final tLat = 10.823099;
    final tLon = 106.629662;
    final tWeatherData = {
      'main': {'temp': 30.5},
      'name': 'Hồ Chí Minh',
    };

    test('trả về WeatherModel khi gọi service thành công', () async {
      // Arrange
      when(
        () => mockWeatherService.fetchCurrentWeather(any(), any()),
      ).thenAnswer((_) async => tWeatherData);

      // Act
      final result = await repository.getCurrentWeather(tLat, tLon);

      // Assert
      expect(result, isA<WeatherModel>());
      expect(result.name, equals('Hồ Chí Minh'));
      expect(result.main?.temp, equals(30.5));
      verify(
        () => mockWeatherService.fetchCurrentWeather(tLat, tLon),
      ).called(1);
    });

    test('ném ServerException khi gọi service thất bại', () async {
      // Arrange
      when(
        () => mockWeatherService.fetchCurrentWeather(any(), any()),
      ).thenThrow(ServerException(message: 'Lỗi server'));

      // Act & Assert
      expect(
        () => repository.getCurrentWeather(tLat, tLon),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getFiveDayForecast', () {
    final tLat = 10.823099;
    final tLon = 106.629662;
    final tCnt = 4;
    final tForecastData = {
      'list': [
        {
          'dt': 1617667200,
          'main': {'temp': 30.5},
        },
      ],
      'city': {'name': 'Hồ Chí Minh'},
    };

    test('trả về ForecastModel khi gọi service thành công', () async {
      // Arrange
      when(
        () => mockWeatherService.fetchFiveDayForecast(
          any(),
          any(),
          cnt: any(named: 'cnt'),
        ),
      ).thenAnswer((_) async => tForecastData);

      // Act
      final result = await repository.getFiveDayForecast(tLat, tLon, cnt: tCnt);

      // Assert
      expect(result, isA<ForecastModel>());
      verify(
        () => mockWeatherService.fetchFiveDayForecast(tLat, tLon, cnt: tCnt),
      ).called(1);
    });

    test('ném ServerException khi gọi service thất bại', () async {
      // Arrange
      when(
        () => mockWeatherService.fetchFiveDayForecast(
          any(),
          any(),
          cnt: any(named: 'cnt'),
        ),
      ).thenThrow(ServerException(message: 'Lỗi server'));

      // Act & Assert
      expect(
        () => repository.getFiveDayForecast(tLat, tLon, cnt: tCnt),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
