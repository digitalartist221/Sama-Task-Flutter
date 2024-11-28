import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Connexion utilisateur
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Erreur lors de la connexion : $e');
    }
  }

  // Déconnexion utilisateur
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Vérifier l'état d'authentification
  User? get currentUser => _auth.currentUser;
}
