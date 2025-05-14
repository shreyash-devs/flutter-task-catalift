import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:async';

// This is a utility file to help create a simple icon
// Since we can't directly convert the AVIF image, we're creating a simple
// colored icon with the app's theme color

Future<void> main() async {
  // The size of the icon
  const int size = 1024;

  // Create a square image with the app's primary color
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  // Draw background
  final paint =
      Paint()
        ..color = const Color(0xFF6C63FF) // Primary color
        ..style = PaintingStyle.fill;

  canvas.drawRect(Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()), paint);

  // Draw a circular overlay
  final circlePaint =
      Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.fill;

  canvas.drawCircle(Offset(size / 2, size / 2), size / 3, circlePaint);

  // Draw a fitness icon
  final iconPaint =
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = size / 20;

  // Draw a simplified dumbbell shape
  canvas.drawLine(
    Offset(size / 4, size / 2),
    Offset(3 * size / 4, size / 2),
    iconPaint,
  );

  canvas.drawCircle(Offset(size / 4, size / 2), size / 10, iconPaint);

  canvas.drawCircle(Offset(3 * size / 4, size / 2), size / 10, iconPaint);

  // Create an image from the canvas
  final picture = recorder.endRecording();
  final img = await picture.toImage(size, size);
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData!.buffer.asUint8List();

  // Save the image
  final iconFile = File('assets/icon/appicon.png');
  await iconFile.writeAsBytes(buffer);

  print('Icon created at assets/icon/appicon.png');
}
