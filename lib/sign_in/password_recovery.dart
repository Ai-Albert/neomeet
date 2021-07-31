import 'package:digital_contact_card/custom_widgets/bouncing_button.dart';
import 'package:digital_contact_card/custom_widgets/outlined_text_button.dart';
import 'package:digital_contact_card/custom_widgets/regular_button.dart';
import 'package:digital_contact_card/custom_widgets/show_alert_dialog.dart';
import 'package:digital_contact_card/sign_in/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordRecovery extends StatefulWidget {
  const PasswordRecovery({Key? key}) : super(key: key);

  @override
  _PasswordRecoveryState createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecovery> with
    EmailAndPasswordValidator, SingleTickerProviderStateMixin {

  /********** TEXT EDITING STUFF **********/

  final TextEditingController _emailController = TextEditingController();
  String get _email => _emailController.text;

  void _updateState() {
    setState(() {});
  }

  /********** UI STUFF **********/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(int.parse('0xFFE53935')), Color(int.parse('0xFF00ACC1'))],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: MediaQuery.of(context).size.width),
              Text(
                'Password Reset',
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
                  labelText: 'Email',
                  labelStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white38)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                ),
                cursorColor: Colors.white,
                controller: _emailController,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: (_email) => _updateState(),
              ),
              SizedBox(height: 30.0),
              _sendButton(),
              _backButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sendButton() {
    return BouncingButton(
      child: OutlinedTextButton(
        width: MediaQuery.of(context).size.width - 40 - 150,
        text: "Send recovery email",
      ),
      onPress: () async {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        Navigator.pop(context);
        showAlertDialog(
          context,
          title: "Email Sent",
          content: "Check your inbox to make a new password",
          defaultActionText: "OK",
        );
      },
    );
  }

  Widget _backButton() {
    return BouncingButton(
      child: RegularButton(
        width: MediaQuery.of(context).size.width - 40 - 150,
        text: "Back",
      ),
      onPress: () => Navigator.pop(context),
    );
  }
}
