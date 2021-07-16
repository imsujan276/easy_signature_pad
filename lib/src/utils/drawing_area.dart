import 'dart:ui';

import 'package:easy_signature_pad/src/models/drawing_area.dart';
import 'package:flutter/material.dart';

class MyCustomPainter extends CustomPainter {
  /// list of points drawn
  List<DrawingArea> points;

  /// creates the transaparent image. Default = false
  bool transparent;

  /// canvas background color
  Color backgroundColor;

  MyCustomPainter(
      {required List<DrawingArea> points,
      required bool transparent,
      required Color backgroundColor})
      : this.points = points.toList(),
        this.transparent = transparent,
        this.backgroundColor = backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()
      ..color = transparent ? Colors.transparent : backgroundColor;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    canvas.clipRect(rect);

    /// an algorithm to draw the points in the canvas
    for (int x = 0; x < points.length - 1; x++) {
      if (points[x].point.isFinite && points[x + 1].point.isFinite) {
        canvas.drawLine(
            points[x].point, points[x + 1].point, points[x].areaPaint);
      } else if (points[x].point.isFinite && !points[x + 1].point.isFinite) {
        canvas.drawPoints(
            PointMode.points, [points[x].point], points[x].areaPaint);
      }
    }
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
