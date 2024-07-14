import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/core/constants.dart';

NavigationRailDestination buildRotatedTextRailDestination(
    String text, int index, int selectedIndex) {
  return NavigationRailDestination(
    label: const SizedBox.shrink(), // No icon
    icon: RotatedBox(
      quarterTurns: -1,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Text(
          text,
          style: GoogleFonts.raleway(
            color: selectedIndex == index ? kGrey : Colors.white,
            backgroundColor: selectedIndex == index ? Colors.white : kGrey,
          ),
        ),
      ),
    ),
  );
}
