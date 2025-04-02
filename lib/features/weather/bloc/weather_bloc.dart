import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:weather_app/core/errors/exceptions.dart';
import 'package:weather_app/features/weather/bloc/weather_event.dart';
import 'package:weather_app/features/weather/bloc/weather_state.dart';
import 'package:weather_app/repositories/weather_repository.dart';
import 'package:weather_app/services/location_service.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  final LocationService locationService;
  final Logger _logger = Logger();

  WeatherBloc({required this.weatherRepository, required this.locationService})
    : super(const WeatherState()) {
    on<WeatherFetched>(_onWeatherFetched, transformer: droppable());
    on<ForecastFetched>(_onForecastFetched, transformer: droppable());
  }

  Future<void> _onWeatherFetched(
    WeatherFetched event,
    Emitter<WeatherState> emit,
  ) async {
    if (state.status == WeatherStatus.loading) return;

    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final Position position = await locationService.getCurrentLocation();
      final weather = await weatherRepository.getCurrentWeather(
        position.latitude,
        position.longitude,
      );

      emit(state.copyWith(status: WeatherStatus.success, weather: weather, currentLocation: position));

      // Tự động lấy dữ liệu dự báo sau khi lấy thời tiết hiện tại
      add(const ForecastFetched());
    } on LocationException catch (e) {
      emit(
        state.copyWith(status: WeatherStatus.failure, errorMessage: e.message),
      );
    } on ServerException catch (e) {
      emit(
        state.copyWith(status: WeatherStatus.failure, errorMessage: e.message),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: WeatherStatus.failure,
          errorMessage: 'Có lỗi xảy ra: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onForecastFetched(
    ForecastFetched event,
    Emitter<WeatherState> emit,
  ) async {
    if (state.weather == null) return;

    try {
      final forecast = await weatherRepository.getFiveDayForecast(
        state.currentLocation?.latitude ?? 0,
        state.currentLocation?.longitude ?? 0,
        cnt: 4
      );

      emit(state.copyWith(forecast: forecast));
    } on ServerException catch (e) {
      // Không thay đổi trạng thái nếu lỗi, chỉ log lỗi
      _logger.w('Không thể lấy dự báo: ${e.message}');
    } catch (e) {
      _logger.e('Lỗi khi lấy dự báo: ${e.toString()}');
    }
  }
}
