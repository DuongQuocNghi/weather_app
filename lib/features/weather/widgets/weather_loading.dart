import 'package:flutter/material.dart';
import 'package:weather_app/core/widgets/rotating_widget.dart';

class WeatherLoading extends StatelessWidget {
  const WeatherLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotatingWidget(
        child: Icon(Icons.autorenew_rounded, size: 96,),
      ),
    );
  }
}
