import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {
  User get currentUser;

  Stream<User?> authStateChanges();
  Future<User?> signInEmail(String email, String password);
  Future<User?> createUserEmail(String email, String password);
  Future<void> signOut();
  Future<void> deleteAccount();
}

class Auth implements AuthBase {

  final _firebaseAuth = FirebaseAuth.instance;
  late String _email;
  late String _password;

  @override
  User get currentUser => _firebaseAuth.currentUser!;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  Future<User?> signInEmail(String email, String password) async {
    this._email = email;
    this._password = password;
    var credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  @override
  Future<User?> createUserEmail(String email, String password) async {
    this._email = email;
    this._password = password;
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  Future<void> deleteAccount() async {
    var credential = EmailAuthProvider.credential(
      email: _email,
      password: _password,
    );
    await currentUser.reauthenticateWithCredential(credential);
    await currentUser.delete();
  }
}