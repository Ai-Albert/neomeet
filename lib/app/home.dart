import 'package:digital_contact_card/app/scanner.dart';
import 'package:digital_contact_card/custom_widgets/bouncing_button.dart';
import 'package:digital_contact_card/custom_widgets/utility_button.dart';
import 'package:digital_contact_card/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../custom_widgets/show_alert_dialog.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // Signs out using Firebase
  Future _signOut() async {
    try {
      await Provider.of<AuthBase>(context, listen: false).signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  // Asks user to sign out
  Future _confirmSignOut(BuildContext context) async {
    final request = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure you want to log out?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Log out',
    );
    if (request) {
      _signOut();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: MediaQuery.of(context).size.width),
            _utilities(),
          ],
        ),
      ),
    );
  }

  Widget _utilities() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BouncingButton(
              child: UtilityButton(
                icon: Icons.qr_code_scanner,
              ),
              onPress: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Scanner(),
              )),
            ),
            SizedBox(width: 25),
            BouncingButton(
              child: UtilityButton(
                icon: Icons.add,
              ),
              onPress: () {},
            ),
          ],
        ),
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BouncingButton(
              child: UtilityButton(
                icon: Icons.settings,
              ),
              onPress: () {},
            ),
            SizedBox(width: 25),
            BouncingButton(
              child: UtilityButton(
                icon: Icons.logout,
              ),
              onPress: () => _confirmSignOut(context),
            ),
          ],
        ),
      ],
    );
  }
}
