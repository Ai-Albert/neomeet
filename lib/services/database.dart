import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_contact_card/models/person.dart';
import 'package:digital_contact_card/services/api_path.dart';
import 'package:digital_contact_card/services/firestore_service.dart';
import 'package:digital_contact_card/models/link_item.dart';
import 'firestore_service.dart';

abstract class Database {
  Stream<List<LinkItem>> linksStream();
  Future<void> setLink(String name, String url);
  Future<void> deleteLink(String name);

  Stream<List<Person>> contactStream();
  Future<void> setContact(Person person);

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

  @override
  Stream<List<Person>> contactStream() => _service.collectionStream(
    path: APIPath.contact(uid),
    builder: (data, _) => Person.fromMap(data),
  );

  // Setting contact info
  @override
  Future<void> setContact(Person person) async => _service.setData(
    path: APIPath.contactDoc(uid),
    data: person.toMap(),
  );

  // Deleting all of a user's data prior to account deletion
  @override
  Future<void> deleteData() async {
    // Deleting contact info
    _service.deleteData(path: APIPath.contactDoc(uid));

    // Deleting links
    var links = FirebaseFirestore.instance.collection(APIPath.links(uid));
    var snapshotsLinks = await links.get();
    for (var link in snapshotsLinks.docs) {
      await this.deleteLink(link.id);
      await link.reference.delete();
    }
  }
}