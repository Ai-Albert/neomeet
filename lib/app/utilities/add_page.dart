import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_contact_card/custom_widgets/bouncing_button.dart';
import 'package:digital_contact_card/custom_widgets/outlined_text_button.dart';
import 'package:digital_contact_card/custom_widgets/regular_button.dart';
import 'package:digital_contact_card/custom_widgets/show_exception_alert_dialog.dart';
import 'package:digital_contact_card/services/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key, required this.database, this.name, this.url}) : super(key: key);

  final Database database;
  final String? name;
  final String? url;

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late String oldName;
  late String name;
  late String url;

  @override
  void initState() {
    super.initState();
    oldName = widget.name ?? '';
    name = widget.name ?? '';
    url = widget.url ?? '';
  }

  Future<void> _setData(BuildContext context) async {
    try {
      if (name == '') throw new FormatException('EMPTY_NAME');
      if (url == '') throw new FormatException('EMPTY_URL');
      if (oldName != '' && oldName != name) await widget.database.deleteLink(oldName);
      await widget.database.setLink(name, url);
      Navigator.of(context).pop([name, url]);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    } on FormatException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Please enter a name',
        exception: e,
      );
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
                'Set a link',
                textAlign: TextAlign.center,
                style: GoogleFonts.comfortaa(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 32.0,
                  ),
                ),
              ),
              SizedBox(height: 50.0),
              _buildName(),
              SizedBox(height: 10),
              _buildLink(),
              SizedBox(height: 30.0),
              BouncingButton(
                child: OutlinedTextButton(
                  text: "Set link",
                  width: 100,
                ),
                onPress: () => _setData(context),
              ),
              BouncingButton(
                child: RegularButton(width: 100, text: "Back"),
                onPress: () => Navigator.of(context).pop([name, url]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildName() {
    return TextField(
      style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white)),
      decoration: InputDecoration(
        labelText: 'Name',
        labelStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white38)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
      cursorColor: Colors.white,
      controller: TextEditingController(text: name),
      autocorrect: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onChanged: (name) => this.name = name,
    );
  }

  Widget _buildLink() {
    return TextField(
      style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white)),
      decoration: InputDecoration(
        labelText: 'Link',
        labelStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white38)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
      cursorColor: Colors.white,
      controller: TextEditingController(text: url),
      autocorrect: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onChanged: (link) => this.url = link,
    );
  }
}
