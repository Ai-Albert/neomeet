import 'package:digital_contact_card/app/qr_page.dart';
import 'package:digital_contact_card/app/utilities/add_page.dart';
import 'package:digital_contact_card/app/helpers/list_items_builder.dart';
import 'package:digital_contact_card/app/utilities/scanner.dart';
import 'package:digital_contact_card/app/utilities/settings.dart';
import 'package:digital_contact_card/custom_widgets/bouncing_button.dart';
import 'package:digital_contact_card/custom_widgets/outlined_text_button.dart';
import 'package:digital_contact_card/custom_widgets/utility_button.dart';
import 'package:digital_contact_card/models/link_item.dart';
import 'package:digital_contact_card/services/auth.dart';
import 'package:digital_contact_card/services/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            Text(
              'Albert Ai',
              style: GoogleFonts.comfortaa(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width - 100,
              child: Divider(color: Colors.white, thickness: 1),
            ),
            SizedBox(height: 300, width: 225, child: _buildLinks(context)),
            SizedBox(height: 50),
            _utilities(),
          ],
        ),
      ),
    );
  }

  Widget _buildLinks(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<LinkItem>>(
      stream: database.linksStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<LinkItem>(
          snapshot: snapshot,
          itemBuilder: (context, link) => BouncingButton(
            child: OutlinedTextButton(
              text: link.name,
              width: MediaQuery.of(context).size.width - 200,
            ),
            onPress: () {
              final database = Provider.of<Database>(context, listen: false);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => QRPage(database: database, name: link.name, url: link.url),
              ));
            }
          ),
        );
      },
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
              onPress: () {
                final database = Provider.of<Database>(context, listen: false);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddPage(database: database),
                ));
              },
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
              onPress: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Settings(),
              )),
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
