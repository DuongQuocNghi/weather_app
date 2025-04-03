import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/exceptions.dart';
import 'package:weather_app/services/weather_service.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  late OpenWeatherMapService weatherService;
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    TestWidgetsFlutterBinding.ensureInitialized();

    // Thiết lập mock cho dotenv
    dotenv.testLoad(
      fileInput: '''
      OPENWEATHER_API_KEY=test_api_key
      OPENWEATHER_BASE_URL=https://api.openweathermap.org
    ''',
    );

    weatherService = OpenWeatherMapService(client: mockHttpClient);
  });

  group('fetchCurrentWeather', () {
    final tLat = 10.823099;
    final tLon = 106.629662;
    final tResponseJson = {
      'main': {'temp': 30.5},
      'name': 'Hồ Chí Minh',
    };
    final tResponseBody = json.encode(tResponseJson);

    test('trả về dữ liệu khi gọi API thành công', () async {
      // Arrange
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.body).thenReturn(tResponseBody);
      when(
        () => mockHttpClient.get(any()),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await weatherService.fetchCurrentWeather(tLat, tLon);

      // Assert
      expect(result, equals(tResponseJson));
      verify(() => mockHttpClient.get(any())).called(1);
    });

    test('ném ServerException khi gọi API thất bại', () async {
      // Arrange
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(404);
      when(() => mockResponse.body).thenReturn('Not Found');
      when(
        () => mockHttpClient.get(any()),
      ).thenAnswer((_) async => mockResponse);

      // Act & Assert
      expect(
        () => weatherService.fetchCurrentWeather(tLat, tLon),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('fetchFiveDayForecast', () {
    final tLat = 10.823099;
    final tLon = 106.629662;
    final tCnt = 5;
    final tResponseJson = {
      'list': [
        {
          'dt': 1617667200,
          'main': {'temp': 30.5},
        },
      ],
      'city': {'name': 'Hồ Chí Minh'},
    };
    final tResponseBody = json.encode(tResponseJson);

    test('trả về dữ liệu khi gọi API thành công', () async {
      // Arrange
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.body).thenReturn(tResponseBody);
      when(
        () => mockHttpClient.get(any()),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await weatherService.fetchFiveDayForecast(
        tLat,
        tLon,
        cnt: tCnt,
      );

      // Assert
      expect(result, equals(tResponseJson));
      verify(() => mockHttpClient.get(any())).called(1);
    });

    test('ném ServerException khi gọi API thất bại', () async {
      // Arrange
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(500);
      when(() => mockResponse.body).thenReturn('Server Error');
      when(
        () => mockHttpClient.get(any()),
      ).thenAnswer((_) async => mockResponse);

      // Act & Assert
      expect(
        () => weatherService.fetchFiveDayForecast(tLat, tLon, cnt: tCnt),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
