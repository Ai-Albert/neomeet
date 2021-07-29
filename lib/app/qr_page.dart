import 'package:digital_contact_card/app/utilities/add_page.dart';
import 'package:digital_contact_card/custom_widgets/bouncing_button.dart';
import 'package:digital_contact_card/custom_widgets/outlined_text_button.dart';
import 'package:digital_contact_card/custom_widgets/regular_button.dart';
import 'package:digital_contact_card/custom_widgets/show_alert_dialog.dart';
import 'package:digital_contact_card/services/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRPage extends StatefulWidget {
  const QRPage({Key? key, required this.database, required this.name, required this.url}) : super(key: key);

  final Database database;
  final String name;
  final String url;

  @override
  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  String name = "";
  String url = "";

  Future _delete() async {
    try {
      await widget.database.deleteLink(name == "" ? widget.name : name);
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
    }
  }

  Future _confirmDelete(BuildContext context) async {
    final request = await showAlertDialog(
      context,
      title: 'Delete',
      content: 'Are you sure you want to delete?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Delete',
    );
    if (request) {
      _delete();
    }
  }

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
                name == "" ? widget.name : name,
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
                child: OutlinedTextButton(
                  text: "Edit",
                  width: 100,
                ),
                onPress: () async {
                  List<String> results = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddPage(
                      database: widget.database,
                      name: name == "" ? widget.name : name,
                      url: url == "" ? widget.url : url,
                    ),
                  ));
                  name = results[0];
                  url = results[1];
                  setState(() {});
                }
              ),
              BouncingButton(
                  child: OutlinedTextButton(
                    text: "Delete",
                    width: 100,
                  ),
                  onPress: () async => _confirmDelete(context),
              ),
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
      data: url == "" ? widget.url : url,
      version: QrVersions.auto,
      size: 300,
    );
  }
}
