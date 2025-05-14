import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoWidget extends StatelessWidget {
  final double fontSize;
  final Color color;

  const LogoWidget({Key? key, this.fontSize = 20.0, this.color = Colors.white})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerLeft,
          children: [
            // Split logo text into bold CATA and regular LIFT parts
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // CATA - Bold part
                Text(
                  'CATA',
                  style: GoogleFonts.poppins(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize + 1,
                    letterSpacing: 1.5,
                    height: 1.1,
                  ),
                ),

                // Create a stack for LIFT part with the line
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // LIFT - Regular part
                    Text(
                      'LIFT',
                      style: GoogleFonts.poppins(
                        color: color,
                        fontWeight: FontWeight.normal,
                        fontSize: fontSize + 1,
                        letterSpacing: 1.5,
                        height: 1.1,
                      ),
                    ),

                    // Line only above LIFT
                    Positioned(
                      top: -2,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 1.5, // Thin line
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
