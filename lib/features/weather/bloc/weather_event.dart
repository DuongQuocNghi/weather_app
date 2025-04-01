import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class WeatherFetched extends WeatherEvent {
  const WeatherFetched();
}

class WeatherRefreshed extends WeatherEvent {
  const WeatherRefreshed();
}

class ForecastFetched extends WeatherEvent {
  const ForecastFetched();
}
