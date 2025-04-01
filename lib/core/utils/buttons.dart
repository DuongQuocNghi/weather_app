import 'package:flutter/material.dart';
import 'package:weather_app/core/assets/colors.dart';

abstract class AppButtons{
  Widget primary({AppColor? apColor});
  Widget secondary({AppColor? apColor});
  Widget subtle({AppColor? apColor});
  Widget outline({AppColor? apColor});
}