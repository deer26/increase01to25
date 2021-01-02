import 'dart:ui';

import 'package:charts_flutter/flutter.dart' as charts;
class PointsModel {
  final String adim;
  final double point;
  final charts.Color color;

  PointsModel(this.adim, this.point, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}