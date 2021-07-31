import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_contact_card/custom_widgets/bouncing_button.dart';
import 'package:digital_contact_card/custom_widgets/color_selector.dart';
import 'package:digital_contact_card/custom_widgets/outlined_text_button.dart';
import 'package:digital_contact_card/custom_widgets/regular_button.dart';
import 'package:digital_contact_card/custom_widgets/show_exception_alert_dialog.dart';
import 'package:digital_contact_card/models/person.dart';
import 'package:digital_contact_card/services/database.dart';
import 'package:digital_contact_card/sign_in/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key, required this.database, required this.person}) : super(key: key);

  final Database database;
  final Person? person;

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> with EmailAndPasswordValidator {
  bool _submitted = false;
  late String fname;
  late String lname;
  late String phone;
  late String email;
  List<String> colors = ['', ''];

  @override
  void initState() {
    super.initState();
    fname = widget.person!.fname;
    lname = widget.person!.lname;
    phone = widget.person!.phoneNumber;
    email = widget.person!.email;
    colors[0] = widget.person!.color1;
    colors[1] = widget.person!.color2;
  }

  Future<void> _saveInfo() async {
    try {
      if (fname == '') throw new FormatException('EMPTY_FIRST_NAME');
      if (lname == '') throw new FormatException('EMPTY_LAST_NAME');
      final Person person = Person(fname: fname, lname: lname, phoneNumber: phone, email: email, color1: colors[0], color2: colors[1]);
      await widget.database.setContact(person);
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    } on FormatException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Please enter a valid name',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool fnameValid = emailValidator.isValid(fname);
    bool lnameValid = emailValidator.isValid(lname);
    bool showFnameError = _submitted && !fnameValid;
    bool showLnameError = _submitted && !lnameValid;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            colors: [Color(int.parse(colors[0])), Color(int.parse(colors[1]))],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width, height: 150),
                Text(
                  'User Settings',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comfortaa(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                TextField(
                  style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white)),
                  decoration: InputDecoration(
                    labelText: 'First name',
                    labelStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white38)),
                    errorText: showFnameError ? 'First name can\'t be empty' : null,
                    errorStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  ),
                  cursorColor: Colors.white,
                  controller: TextEditingController(text: fname),
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  onChanged: (fname) => this.fname = fname,
                ),
                SizedBox(height: 10.0),
                TextField(
                  style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white)),
                  decoration: InputDecoration(
                    labelText: 'Last name',
                    labelStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white38)),
                    errorText: showLnameError ? 'Last name can\'t be empty' : null,
                    errorStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  ),
                  cursorColor: Colors.white,
                  controller: TextEditingController(text: lname),
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  onChanged: (lname) => this.lname = lname,
                ),
                SizedBox(height: 10.0),
                TextField(
                  style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white)),
                  decoration: InputDecoration(
                    labelText: 'Phone number',
                    labelStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white38)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  ),
                  cursorColor: Colors.white,
                  controller: TextEditingController(text: phone),
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onChanged: (phone) => this.phone = phone,
                ),
                SizedBox(height: 10.0),
                TextField(
                  style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white)),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white38)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  ),
                  cursorColor: Colors.white,
                  controller: TextEditingController(text: email),
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onChanged: (email) => this.email = email,
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Color:',
                      style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white)),
                    ),
                    ColorSelector(colors: colors, colorNum: 0),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bottom Color:',
                      style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white)),
                    ),
                    ColorSelector(colors: colors, colorNum: 1),
                  ],
                ),
                SizedBox(height: 30),
                BouncingButton(
                  child: OutlinedTextButton(
                    text: "Save",
                    width: 75,
                  ),
                  onPress: () => _saveInfo(),
                ),
                BouncingButton(
                  child: RegularButton(width: 100, text: "Back"),
                  onPress: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
