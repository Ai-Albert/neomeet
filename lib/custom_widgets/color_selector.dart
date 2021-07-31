import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorSelector extends StatefulWidget {
  const ColorSelector({Key? key, required this.colors, required this.colorNum}) : super(key: key);
  final List<String> colors;
  final int colorNum;

  @override
  _ColorSelectorState createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  Map<String, String> colorMap1 = {
    'Red': '0xFFE53935',
    'Orange': '0xFFE64A19',
    'Yellow': '0xFFFDD835',
    'Green': '0xFF43A047',
    'Teal': '0xFF009688',
    'Cyan': '0xFF00ACC1',
    'Blue': '0xFF0288D1',
    'Purple': '0xFF8E24AA',
    'Pink': '0xFFD81B60',
  };
  Map<String, String> colorMap2 = {
    '0xFFE53935': 'Red',
    '0xFFE64A19': 'Orange',
    '0xFFFDD835': 'Yellow',
    '0xFF43A047': 'Green',
    '0xFF009688': 'Teal',
    '0xFF00ACC1': 'Cyan',
    '0xFF0288D1': 'Blue',
    '0xFF8E24AA': 'Purple',
    '0xFFD81B60': 'Pink',
  };
  late String? currColor;

  @override
  void initState() {
    super.initState();
    currColor = colorMap2[widget.colors[widget.colorNum]];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      iconEnabledColor: Colors.white,
      dropdownColor: Colors.black,
      value: currColor!,
      style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white)),
      items: <String>[
        'Red',
        'Orange',
        'Yellow',
        'Green',
        'Teal',
        'Cyan',
        'Blue',
        'Purple',
        'Pink',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: GoogleFonts.montserrat(),
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          currColor = value;
          widget.colors[widget.colorNum] = colorMap1[value!]!;
        });
      },
    );
  }
}
