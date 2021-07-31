import 'package:digital_contact_card/custom_widgets/bouncing_button.dart';
import 'package:digital_contact_card/custom_widgets/outlined_text_button.dart';
import 'package:digital_contact_card/custom_widgets/regular_button.dart';
import 'package:digital_contact_card/custom_widgets/show_alert_dialog.dart';
import 'package:digital_contact_card/models/person.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  late QRViewController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future _confirmAddContact(BuildContext context, Contact contact) async {
    final request = await showAlertDialog(
      context,
      title: 'Add ${contact.name.first} ${contact.name.last}',
      content: 'Add new contact?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Add',
    );
    if (request) {
      await contact.insert();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          flex: 6,
          child: Stack(
            children: [
              QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red[400]!,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BouncingButton(
                child: RegularButton(width: 50, text: "Back"),
                onPress: () => Navigator.of(context).pop(),
              ),
              BouncingButton(
                child: OutlinedTextButton(width: 100, text: "Toggle Flash"),
                onPress: () async => await controller.toggleFlash(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      if (scanData.code.startsWith('MECARD')) {
        final person = Person.fromString(scanData.code);
        final contact = Contact()
          ..name.first = person.fname
          ..name.last = person.lname
          ..phones = [Phone(person.phoneNumber)]
          ..emails = [Email(person.email)];
        if (await FlutterContacts.requestPermission()) _confirmAddContact(context, contact);
        controller.resumeCamera();
      }
      else if (await canLaunch(scanData.code)) {
        await launch(scanData.code);
        controller.resumeCamera();
      }
      else {
        print(scanData.code);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Could not find viable code'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Barcode Type: ${describeEnum(scanData.format)}'),
                    Text('Data: ${scanData.code}'),
                    Text('NOTE: contact info must be in mecard format (not vcard)'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ).then((value) => controller.resumeCamera());
      }
    });
  }
}
