class Person {
  Person({
    required this.fname,
    required this.lname,
    required this.phoneNumber,
    required this.email,
    required this.color1,
    required this.color2,
  });

  final String fname;
  final String lname;
  final String phoneNumber;
  final String email;
  final String color1;
  final String color2;

  factory Person.fromMap(Map<String, dynamic>? data) {
    if (data == null) return Person(
      fname: 'FIRST',
      lname: 'LAST',
      phoneNumber: 'N/A',
      email: 'N/A',
      color1: '0xFFE53935',
      color2: '0xFF00ACC1',
    );
    return Person.fromString(data['vcard'], data['color1'], data['color2']);
  }

  factory Person.fromString(String? data, String? color1, String? color2) {
    if (data == null) return Person(
      fname: 'FIRST',
      lname: 'LAST',
      phoneNumber: 'N/A',
      email: 'N/A',
      color1: '0xFFE53935',
      color2: '0xFF00ACC1',
    );
    List<String> split = data.split(';');
    return Person(
      fname: split[0].split(',')[1],
      lname: split[0].split(',')[0].substring(9),
      phoneNumber: split[1].substring(4),
      email: split[2].substring(6),
      color1: color1!,
      color2: color2!,
    );
  }

  Map<String, String> toMap() {
    String vCard = 'MECARD:N:$lname,$fname;TEL:$phoneNumber;EMAIL:$email;';
    return {
      'vcard': vCard,
      'color1': color1,
      'color2': color2,
    };
  }
}