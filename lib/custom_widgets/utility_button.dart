import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UtilityButton extends StatefulWidget {
  const UtilityButton({Key? key, required this.icon}) : super(key: key);

  final IconData icon;

  @override
  _UtilityButtonState createState() => _UtilityButtonState();
}

class _UtilityButtonState extends State<UtilityButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => HapticFeedback.lightImpact(),
      child: SizedBox(
        child: Icon(widget.icon, color: Colors.white),
        height: 50.0,
        width: 50.0,
      ),
      style: ButtonStyle(
        overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: BorderSide(color: Colors.white),
        )),
      ),
    );
  }
}
