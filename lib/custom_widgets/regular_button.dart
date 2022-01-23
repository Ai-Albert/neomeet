import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RegularButton extends StatelessWidget {
  const RegularButton({
    Key? key,
    required this.width,
    required this.text,
  }) : super(key: key);

  final double width;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: SizedBox(
        width: width,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white)),
        ),
      ),
      onPressed: () => HapticFeedback.lightImpact(),
      style: ButtonStyle(
        overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        )),
      ),
    );
  }
}
