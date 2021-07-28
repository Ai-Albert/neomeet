import 'package:digital_contact_card/custom_widgets/show_alert_dialog.dart';
import 'package:digital_contact_card/sign_in/valildators.dart';
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

  /********** ANIMATION STUFF **********/

  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 70),
      lowerBound: 0.0,
      upperBound: 0.07,
    )..addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }

  /********** UI STUFF **********/

  @override
  Widget build(BuildContext context) {
    bool emailValid = emailValidator.isValid(_email);
    _scale = 1 - _controller.value;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue, Colors.red],
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
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white38),
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
              GestureDetector(
                onTapDown: _tapDown,
                onTapUp: _tapUp,
                child: Transform.scale(
                  scale: _scale,
                  child: _sendButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sendButton() {
    return TextButton(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 40 - 150,
        child: Text(
          "Send recovery email",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
      onPressed: () async {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        Navigator.pop(context);
        showAlertDialog(
          context,
          title: "Email Sent",
          content: "Check your inbox to make a new password",
          defaultActionText: "OK",
        );
      },
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
