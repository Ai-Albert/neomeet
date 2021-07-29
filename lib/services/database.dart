import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_contact_card/services/api_path.dart';
import 'package:digital_contact_card/services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:digital_contact_card/models/link_item.dart';
import 'firestore_service.dart';

abstract class Database {
  Stream<List<LinkItem>> linksStream();
  Future<void> setLink(String name, String url);
  Future<void> deleteLink(String name);
  Future<void> deleteData();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;
  final _service = FirestoreService.instance;

  @override
  Stream<List<LinkItem>> linksStream() => _service.collectionStream(
    path: APIPath.links(uid),
    builder: (data, id) => LinkItem.fromMap(data, id),
    sort: (a, b) => a.name.compareTo(b.name),
  );

  // Adding or updating a link
  @override
  Future<void> setLink(String name, String url) async => _service.setData(
    path: APIPath.link(uid, name),
    data: {'url': url},
  );

  // Removing a link
  @override
  Future<void> deleteLink(String name) async => _service.deleteData(
    path: APIPath.link(uid, name),
  );

  // Deleting all of a user's data prior to account deletion
  @override
  Future<void> deleteData() async {
    //
  }
}