import 'dart:math' as math;
import 'package:flutter/material.dart';

class SensorGauge extends StatelessWidget {
  final double value;
  final double minVal;
  final double maxVal;
  final String label;
  final String unit;
  final Color color;

  const SensorGauge({
    super.key,
    required this.value,
    required this.minVal,
    required this.maxVal,
    required this.label,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight);
        final clampedValue = value.clamp(minVal, maxVal);
        final percentage = (clampedValue - minVal) / (maxVal - minVal);

        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              children: [
                // Custom Paint for the circular arcs
                Positioned.fill(
                  child: CustomPaint(
                    painter: _GaugePainter(
                      percentage: percentage,
                      color: color,
                      trackColor: color.withOpacity(0.1),
                    ),
                  ),
                ),
                // Center text
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: size * 0.18,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: size * 0.09,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double percentage;
  final Color color;
  final Color trackColor;

  _GaugePainter({
    required this.percentage,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;
    
    const startAngle = math.pi * 0.75;
    const sweepAngle = math.pi * 1.5;

    // Paint configuration for the background track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    // Paint configuration for the active value arc
    final valuePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final activeSweep = sweepAngle * percentage;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      activeSweep,
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor;
  }
}
