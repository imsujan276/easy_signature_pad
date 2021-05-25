library signature_pad;

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:signature_pad/utils/drawing_area.dart';
import 'dart:ui' as ui;

class SignaturePad extends StatefulWidget {
  final ValueChanged<String> onChnaged;
  final int height;
  final int width;
  final Color penColor;
  final double strokeWidth;
  final double borderRadius;
  final bool enableShadow;

  SignaturePad({
    Key key,
    @required this.onChnaged,
    this.height = 256,
    this.width = 400,
    this.penColor = Colors.black,
    this.strokeWidth = 2.0,
    this.borderRadius = 10,
    this.enableShadow = false,
  }) : super(key: key);

  @override
  _SignaturePadState createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  final List<DrawingArea> points = [];

  Future<String> saveToImage(List<DrawingArea> points) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
        recorder,
        Rect.fromPoints(
          Offset(0.0, 0.0),
          Offset(widget.width.toDouble(), widget.height.toDouble()),
        ));
    Paint paint = Paint()
      ..color = widget.penColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = widget.strokeWidth;
    //background
    final paint2 = paint
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    canvas.drawRect(
        Rect.fromLTWH(0, 0, widget.width.toDouble(), widget.height.toDouble()),
        paint2);

    for (int x = 0; x < points.length - 1; x++) {
      if (points[x] != null && points[x + 1] != null) {
        canvas.drawLine(
            points[x].point, points[x + 1].point, points[x].areaPaint);
      } else if (points[x] != null && points[x + 1] == null) {
        canvas.drawPoints(
            PointMode.points, [points[x].point], points[x].areaPaint);
      }
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(widget.width, widget.height);

    //converting to png
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    if (pngBytes != null) {
      final listBytes = Uint8List.view(pngBytes.buffer);
      String b64Image = base64Encode(listBytes);
      return b64Image;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          width: widget.width.toDouble(),
          height: widget.height.toDouble(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(widget.borderRadius),
            ),
            boxShadow: widget.enableShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 5.0,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: GestureDetector(
            onPanDown: (details) {
              this.setState(() {
                points.add(
                  DrawingArea(
                    point: details.localPosition,
                    areaPaint: Paint()
                      ..strokeCap = StrokeCap.round
                      ..isAntiAlias = true
                      ..color = widget.penColor
                      ..strokeWidth = widget.strokeWidth,
                  ),
                );
              });
            },
            onPanUpdate: (details) {
              this.setState(() {
                points.add(
                  DrawingArea(
                    point: details.localPosition,
                    areaPaint: Paint()
                      ..strokeCap = StrokeCap.round
                      ..isAntiAlias = true
                      ..color = widget.penColor
                      ..strokeWidth = widget.strokeWidth,
                  ),
                );
              });
            },
            onPanEnd: (details) async {
              this.setState(() {
                points.add(null);
              });
              widget.onChnaged(await saveToImage(points));
            },
            child: Stack(
              children: [
                SizedBox.expand(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(widget.borderRadius),
                    ),
                    child: CustomPaint(
                      painter: MyCustomPainter(points: points),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        points.clear();
                      });
                      widget.onChnaged(await saveToImage(points));
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(widget.borderRadius),
                        ),
                      ),
                      child: Icon(Icons.clear),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
