import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/src/models/forecast_model.dart';

class ForecastItemWidget extends StatelessWidget {
  final ForecastItem item;

  const ForecastItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format thời gian
    final dateTime = DateTime.fromMillisecondsSinceEpoch(item.dt * 1000);
    final timeFormatter = DateFormat('HH:mm');
    final dateFormatter = DateFormat('dd/MM');

    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hiển thị thời gian
          Text(
            timeFormatter.format(dateTime),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            dateFormatter.format(dateTime),
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),

          // Hiển thị biểu tượng thời tiết
          Image.network(item.weather.first.iconUrl, width: 45, height: 45),
          const SizedBox(height: 8),

          // Hiển thị nhiệt độ
          Text(
            '${item.main.temp.round()}°C',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          // Mô tả thời tiết
          Text(
            item.weather.first.description,
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
