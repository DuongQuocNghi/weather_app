import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/exceptions.dart';
import 'package:weather_app/features/weather/bloc/weather_bloc.dart';
import 'package:weather_app/features/weather/bloc/weather_event.dart';
import 'package:weather_app/features/weather/bloc/weather_state.dart';
import 'package:weather_app/repositories/weather_repository.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/models/forecast_model.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockLocationService extends Mock implements LocationService {}

class MockPosition extends Mock implements Position {
  @override
  final double latitude = 10.823099;
  @override
  final double longitude = 106.629662;
}

void main() {
  late WeatherBloc weatherBloc;
  late MockWeatherRepository mockWeatherRepository;
  late MockLocationService mockLocationService;
  late MockPosition mockPosition;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    mockLocationService = MockLocationService();
    mockPosition = MockPosition();
    weatherBloc = WeatherBloc(
      weatherRepository: mockWeatherRepository,
      locationService: mockLocationService,
    );
  });

  tearDown(() {
    weatherBloc.close();
  });

  test('trạng thái ban đầu là WeatherStatus.initial', () {
    expect(weatherBloc.state.status, equals(WeatherStatus.initial));
  });

  group('WeatherFetched event', () {
    final tWeather = WeatherModel(
      main: MainWeather(temp: 30.5),
      name: 'Hồ Chí Minh',
    );

    final tForecast = ForecastModel.fromJson({
      'list': [
        {
          'dt': 1617667200,
          'main': {'temp': 30.5},
        },
      ],
      'city': {'name': 'Hồ Chí Minh'},
    });

    blocTest<WeatherBloc, WeatherState>(
      'phát ra [loading, success] khi lấy dữ liệu thành công',
      build: () {
        when(
          () => mockLocationService.getCurrentLocation(),
        ).thenAnswer((_) async => mockPosition);
        when(
          () => mockWeatherRepository.getCurrentWeather(any(), any()),
        ).thenAnswer((_) async => tWeather);
        when(
          () => mockWeatherRepository.getFiveDayForecast(
            any(),
            any(),
            cnt: any(named: 'cnt'),
          ),
        ).thenAnswer((_) async => tForecast);
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const WeatherFetched()),
      expect:
          () => [
            const WeatherState(status: WeatherStatus.loading),
            isA<WeatherState>()
                .having(
                  (state) => state.status,
                  'status',
                  WeatherStatus.success,
                )
                .having((state) => state.weather, 'weather', tWeather)
                .having(
                  (state) => state.currentLocation,
                  'currentLocation',
                  mockPosition,
                ),
            isA<WeatherState>()
                .having(
                  (state) => state.status,
                  'status',
                  WeatherStatus.success,
                )
                .having((state) => state.weather, 'weather', tWeather)
                .having((state) => state.forecast, 'forecast', tForecast),
          ],
      verify: (_) {
        verify(() => mockLocationService.getCurrentLocation()).called(1);
        verify(
          () => mockWeatherRepository.getCurrentWeather(any(), any()),
        ).called(1);
        verify(
          () => mockWeatherRepository.getFiveDayForecast(
            any(),
            any(),
            cnt: any(named: 'cnt'),
          ),
        ).called(1);
      },
    );

    blocTest<WeatherBloc, WeatherState>(
      'phát ra [loading, failure] khi lấy vị trí thất bại',
      build: () {
        when(
          () => mockLocationService.getCurrentLocation(),
        ).thenThrow(LocationException(message: 'Không thể lấy vị trí'));
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const WeatherFetched()),
      expect:
          () => [
            const WeatherState(status: WeatherStatus.loading),
            isA<WeatherState>()
                .having(
                  (state) => state.status,
                  'status',
                  WeatherStatus.failure,
                )
                .having(
                  (state) => state.errorMessage,
                  'errorMessage',
                  'Không thể lấy vị trí',
                ),
          ],
      verify: (_) {
        verify(() => mockLocationService.getCurrentLocation()).called(1);
        verifyNever(
          () => mockWeatherRepository.getCurrentWeather(any(), any()),
        );
      },
    );

    blocTest<WeatherBloc, WeatherState>(
      'phát ra [loading, failure] khi lấy thời tiết thất bại',
      build: () {
        when(
          () => mockLocationService.getCurrentLocation(),
        ).thenAnswer((_) async => mockPosition);
        when(
          () => mockWeatherRepository.getCurrentWeather(any(), any()),
        ).thenThrow(ServerException(message: 'Lỗi server'));
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const WeatherFetched()),
      expect:
          () => [
            const WeatherState(status: WeatherStatus.loading),
            isA<WeatherState>()
                .having(
                  (state) => state.status,
                  'status',
                  WeatherStatus.failure,
                )
                .having(
                  (state) => state.errorMessage,
                  'errorMessage',
                  'Lỗi server',
                ),
          ],
      verify: (_) {
        verify(() => mockLocationService.getCurrentLocation()).called(1);
        verify(
          () => mockWeatherRepository.getCurrentWeather(any(), any()),
        ).called(1);
      },
    );
  });
}
