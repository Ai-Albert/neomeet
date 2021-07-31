import 'package:flutter_contacts/contact.dart';

class Person {
  Person({required this.fname, required this.lname, required this.phoneNumber, required this.email});

  final String fname;
  final String lname;
  final String phoneNumber;
  final String email;

  factory Person.fromMap(Map<String, dynamic>? data) {
    if (data == null) return Person(fname: 'FIRST', lname: 'LAST', phoneNumber: 'N/A', email: 'N/A');
    return Person.fromString(data['vcard']);
  }

  factory Person.fromString(String? data) {
    if (data == null) return Person(fname: 'FIRST', lname: 'LAST', phoneNumber: 'N/A', email: 'N/A');
    List<String> split = data.split(';');
    return Person(
      fname: split[0].split(',')[1],
      lname: split[0].split(',')[0].substring(9),
      phoneNumber: split[1].substring(4),
      email: split[2].substring(6),
    );
  }

  Map<String, String> toMap() {
    String vCard = 'MECARD:N:$lname,$fname;TEL:$phoneNumber;EMAIL:$email;';
    return {
      'vcard': vCard,
    };
  }
}