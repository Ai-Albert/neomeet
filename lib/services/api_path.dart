class APIPath {
  static String links(String uid) =>
      'users/$uid/links';
  static String link(String uid, String name) =>
      'users/$uid/links/$name';

  static String contact(String uid) =>
      'users/$uid/contact';
  static String contactDoc(String uid) =>
      'users/$uid/contact/contact';
}