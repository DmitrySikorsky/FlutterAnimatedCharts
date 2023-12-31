import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animated_charts/chart_point.dart';
import 'package:flutter_animated_charts/dimensions.dart';
import 'package:flutter_animated_charts/palette.dart';

class LineChartPainter extends CustomPainter {
  BuildContext context;
  List<ChartPoint> points;

  LineChartPainter(
    this.context,
    this.points,
  );

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0, size.height);
    canvas.scale(1, -1);

    double xFactor = size.width / (points.length - 1);
    double yFactor = size.height / points.map((point) => point.y).max;

    _drawBackground(canvas, size, xFactor, yFactor);
    _drawForeground(canvas, xFactor, yFactor);
  }

  void _drawBackground(Canvas canvas, Size size, double xFactor, double yFactor) {
    for (int i = 0; i != points.length; i++) {
      Paint paint = Paint();

      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = Dimensions.line;
      paint.color = Palette.colors[0].withOpacity(0.15);

      Path path = Path();

      path.moveTo(i * xFactor, 0);
      path.lineTo(i * xFactor, size.height);
      canvas.drawPath(path, paint);
    }

    double yValueStep = points.map((point) => point.y).max / 10.0;

    for (int i = 0; i != 10 + 1; i++) {
      Paint paint = Paint();

      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = Dimensions.line;
      paint.color = Palette.colors[0].withOpacity(0.15);

      Path path = Path();

      path.moveTo(0, i * yValueStep * yFactor);
      path.lineTo(size.width, i * yValueStep * yFactor);
      canvas.drawPath(path, paint);
    }
  }

  void _drawForeground(Canvas canvas, double xFactor, double yFactor) {
    Paint paint = Paint();

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = Dimensions.line * 3.0;
    paint.color = Palette.colors[8];

    Path path = Path();

    for (int i = 0; i != points.length; i++) {
      double yValue = points[i].y;

      if (i == 0) {
        path.moveTo(0, yValue * yFactor);
      } else {
        double previousValue = points[i - 1].y;
        double previousX = (i - 1) * xFactor;
        double previousY = previousValue * yFactor;
        double x = i * xFactor;
        double y = yValue * yFactor;
        double controlX = previousX + (x - previousX) / 2.0;

        path.cubicTo(controlX, previousY, controlX, y, x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
