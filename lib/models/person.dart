class Person {
  Person({required this.fname, required this.lname, required this.phoneNumber, required this.email});

  final String fname;
  final String lname;
  final String phoneNumber;
  final String email;

  factory Person.fromMap(Map<String, dynamic>? data) {
    if (data == null) return Person(fname: 'FIRST', lname: 'LAST', phoneNumber: '8008888888', email: 'N/A');
    var splitString = data['contact']!.split(';');
    return Person(fname: splitString[1], lname: splitString[2], phoneNumber: splitString[3], email: splitString[4]);
  }

  factory Person.fromString(String? data) {
    if (data == null) return Person(fname: 'FIRST', lname: 'LAST', phoneNumber: '8008888888', email: 'N/A');
    var splitString = data.split(';');
    return Person(fname: splitString[1], lname: splitString[2], phoneNumber: splitString[3], email: splitString[4]);
  }

  Map<String, String> toMap() {
    return {
      'contact': 'CONTACT;$fname;$lname;$phoneNumber;$email',
    };
  }
}