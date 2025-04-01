import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/features/weather/widgets/forecast_item.dart';
import 'package:weather_app/src/models/forecast_model.dart';
import 'package:weather_app/src/generated/i18n/app_localizations.dart';

class FiveDayForecast extends StatelessWidget {
  final ForecastModel forecast;

  const FiveDayForecast({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.blue.shade800,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)?.five_day_forecast ??
                  'Dự báo 5 ngày',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildGroupedForecastList(),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupedForecastList() {
    return Expanded(
      child: GroupedListView<ForecastItem, String>(
        elements: forecast.forecastList,
        groupBy: (item) {
          final date = DateTime.fromMillisecondsSinceEpoch(item.dt * 1000);
          return DateFormat('yyyy-MM-dd').format(date);
        },
        groupSeparatorBuilder: (String groupByValue) {
          final date = DateFormat('yyyy-MM-dd').parse(groupByValue);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              DateFormat('EEEE, dd/MM').format(date),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          );
        },
        itemBuilder: (context, item) {
          return ForecastItemWidget(item: item);
        },
        itemComparator: (item1, item2) => item1.dt.compareTo(item2.dt),
        useStickyGroupSeparators: true,
        floatingHeader: true,
        order: GroupedListOrder.ASC,
      ),
    );
  }
}
