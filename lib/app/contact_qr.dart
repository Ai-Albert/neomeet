import 'package:digital_contact_card/custom_widgets/bouncing_button.dart';
import 'package:digital_contact_card/custom_widgets/regular_button.dart';
import 'package:digital_contact_card/models/person.dart';
import 'package:digital_contact_card/services/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ContactQR extends StatefulWidget {
  const ContactQR({Key? key, required this.database, required this.person}) : super(key: key);

  final Database database;
  final Person person;

  @override
  _ContactQRState createState() => _ContactQRState();
}

class _ContactQRState extends State<ContactQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.red[400]!, Colors.cyanAccent[700]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: MediaQuery.of(context).size.width),
              Text(
                '${widget.person.fname} ${widget.person.lname}',
                textAlign: TextAlign.center,
                style: GoogleFonts.comfortaa(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ),
              SizedBox(height: 50.0),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: _buildQR(),
                ),
              ),
              SizedBox(height: 30.0),
              BouncingButton(
                child: RegularButton(width: 100, text: "Back"),
                onPress: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQR() {
    return QrImage(
      data: widget.person.toMap()['contact']!,
      version: QrVersions.auto,
      size: 300,
    );
  }
}