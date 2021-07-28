import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_contact_card/services/api_path.dart';
import 'package:digital_contact_card/services/firestore_service.dart';
import 'package:intl/intl.dart';

import 'firestore_service.dart';

abstract class Database {
  Future<void> deleteData();
}

// For creating unique ids for new entries
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;

  final _service = FirestoreService.instance;

  // Deleting all of a user's data prior to account deletion
  @override
  Future<void> deleteData() async {
    //
  }
}