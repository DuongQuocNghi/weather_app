import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/widgets/five_day_forecast.dart';
import 'package:weather_app/src/models/forecast_model.dart';
import 'package:weather_app/src/models/weather_model.dart';

void main() {
  late ForecastModel model;

  setUp(() {
    model = ForecastModel(
      list: [
        ForecastItem(
          temp: DayTemp(
            day: 32
          ),
          dt: DateTime(2025, 01, 01)
        ),
        ForecastItem(
          main: MainWeather(
              temp: -27.5
          ),
          dt: DateTime(2025, 01, 02)
        ),
      ]
    );
  });

  testWidgets('hiển thị thông tin thứ trong tuần và nhiệt độ chính xác', (
      tester,
      ) async {
    // Render widget
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: FiveDayForecast(forecast: model,))),
    );

    // Đợi các animation hoàn thành
    await tester.pumpAndSettle();

    // Kiểm tra hiển thị nhiệt độ
    expect(find.text('32.0 C'), findsOneWidget);
    expect(find.text('-27.5 C'), findsOneWidget);

    // Kiểm tra thứ trong tuần
    expect(find.text('Wednesday'), findsOneWidget);
    expect(find.text('Thursday'), findsOneWidget);
  });
}
