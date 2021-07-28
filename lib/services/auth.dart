import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {
  User get currentUser;
  AuthCredential get userCredential;
  Stream<User?> authStateChanges();
  Future<User?> signInEmail(String email, String password);
  Future<User?> createUserEmail(String email, String password);
  Future<void> signOut();
  Future<void> deleteAccount();
}

class Auth implements AuthBase {

  final _firebaseAuth = FirebaseAuth.instance;
  late AuthCredential credential;

  @override
  User get currentUser => _firebaseAuth.currentUser!;

  @override
  AuthCredential get userCredential => this.credential;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  Future<User?> signInEmail(String email, String password) async {
    this.credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(this.credential);
    return userCredential.user;
  }

  @override
  Future<User?> createUserEmail(String email, String password) async {
    this.credential = EmailAuthProvider.credential(email: email, password: password);
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
    print("credential: ${this.credential}");
    await currentUser.reauthenticateWithCredential(this.credential);
    await currentUser.delete();
  }
}