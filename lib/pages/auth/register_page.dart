import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task/pages/auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() async {
    try {
      // Inscription avec Firebase Auth
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Si l'inscription réussie, affichage d'un message de succès
      Get.snackbar(
        'Succès',
        'Inscription réussie',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.primary,
        colorText: Colors.white,
      );

      // Rediriger vers la page de connexion
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs d'inscription
      Get.snackbar(
        'Erreur',
        e.message ?? 'Une erreur est survenue',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.error,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo en haut du formulaire
                Image.asset(
                  'assets/images/logo.png',
                  height: 100, // Hauteur du logo
                  fit: BoxFit.contain, // Adaptation de l'image
                ),
                const SizedBox(height: 20),
                Text(
                  "Créer un compte",
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nom",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Mot de passe",
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  child: const Text(
                    "S'inscrire",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: Text(
                    "Déjà un compte ? Se connecter",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
