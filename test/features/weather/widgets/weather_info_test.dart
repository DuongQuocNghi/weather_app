import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/features/weather/widgets/weather_info.dart';
import 'package:weather_app/src/models/weather_model.dart';

void main() {
  late WeatherModel weatherModel;

  setUp(() {
    weatherModel = WeatherModel(
      main: MainWeather(temp: 30.5),
      name: 'Hồ Chí Minh',
    );
  });

  testWidgets('hiển thị thông tin nhiệt độ và tên thành phố chính xác', (
    tester,
  ) async {
    // Render widget
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: WeatherInfo(weather: weatherModel))),
    );

    // Đợi các animation hoàn thành
    await tester.pumpAndSettle();

    // Kiểm tra hiển thị nhiệt độ
    expect(
      find.text('31°'),
      findsOneWidget,
    ); // Temperature should be rounded to nearest integer

    // Kiểm tra hiển thị tên thành phố
    expect(find.text('Hồ Chí Minh'), findsOneWidget);
  });

  testWidgets('xử lý đúng khi nhiệt độ là số âm', (tester) async {
    // Tạo dữ liệu thời tiết với nhiệt độ âm
    final coldWeather = WeatherModel(
      main: MainWeather(temp: -5.2),
      name: 'Hà Nội',
    );

    // Render widget
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: WeatherInfo(weather: coldWeather))),
    );

    // Đợi các animation hoàn thành
    await tester.pumpAndSettle();

    // Kiểm tra hiển thị nhiệt độ âm
    expect(find.text('-5°'), findsOneWidget);

    // Kiểm tra hiển thị tên thành phố
    expect(find.text('Hà Nội'), findsOneWidget);
  });
}
