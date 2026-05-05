import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:flutter/material.dart';

/// Dashed-outline drop zone. The dashed border is painted via [CustomPainter]
/// so it doesn't need an extra package.
class DropZone extends StatelessWidget {
  final bool active;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const DropZone({
    super.key,
    required this.active,
    required this.child,
    this.padding = const EdgeInsets.all(32),
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return AnimatedContainer(
      duration: AppTokens.motionMed,
      curve: AppTokens.motionCurve,
      decoration: BoxDecoration(
        color: active ? t.accentSoft : t.surface3,
        borderRadius: BorderRadius.circular(AppTokens.radius),
      ),
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: active ? t.accent : t.borderStrong,
          radius: AppTokens.radius,
          dashWidth: 6,
          gapWidth: 4,
          strokeWidth: 1.5,
        ),
        child: Padding(
          padding: padding,
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double dashWidth;
  final double gapWidth;
  final double strokeWidth;

  _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.dashWidth,
    required this.gapWidth,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = (distance + dashWidth).clamp(0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next.toDouble()), paint);
        distance = next + gapWidth;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color ||
      old.radius != radius ||
      old.dashWidth != dashWidth ||
      old.gapWidth != gapWidth ||
      old.strokeWidth != strokeWidth;
}
