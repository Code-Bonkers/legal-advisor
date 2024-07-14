import 'dart:ui';

import 'package:flutter/material.dart';

class RotatedRectangleBorder extends ShapeBorder {
  final BorderRadius borderRadius;
  final double width;
  final double height;

  const RotatedRectangleBorder({
    required this.borderRadius,
    required this.width,
    required this.height,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  ShapeBorder scale(double t) {
    return RotatedRectangleBorder(
      borderRadius: borderRadius * t,
      width: width * t,
      height: height * t,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Rect rotatedRect = Rect.fromLTWH(
      rect.left + (rect.width - height) / 2,
      rect.top + (rect.height - width) / 2,
      height,
      width,
    );
    return Path()
      ..addRRect(borderRadius.toRRect(rotatedRect))
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is RotatedRectangleBorder) {
      return RotatedRectangleBorder(
        borderRadius: BorderRadius.lerp(a.borderRadius, borderRadius, t)!,
        width: lerpDouble(a.width, width, t)!,
        height: lerpDouble(a.height, height, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is RotatedRectangleBorder) {
      return RotatedRectangleBorder(
        borderRadius: BorderRadius.lerp(borderRadius, b.borderRadius, t)!,
        width: lerpDouble(width, b.width, t)!,
        height: lerpDouble(height, b.height, t)!,
      );
    }
    return super.lerpTo(b, t);
  }
}
