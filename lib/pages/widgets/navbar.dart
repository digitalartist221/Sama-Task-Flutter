import 'package:flutter/material.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final String avatarUrl; // URL ou chemin local de l'avatar
  final VoidCallback onLogout;
  final VoidCallback onCalendar;
  final bool isHomePage; // Paramètre pour vérifier si c'est la page d'accueil

  const NavBar({
    Key? key,
    required this.avatarUrl,
    required this.onLogout,
    required this.onCalendar,
    this.isHomePage = false, // Valeur par défaut à false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: !isHomePage && Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Retour à la page précédente
              },
            )
          : null, // Pas de bouton retour sur la page d'accueil
      title: Image.asset(
        'assets/images/logo.png', // Chemin vers le logo
        height: 40, // Hauteur du logo
        fit: BoxFit.contain, // Adapter l'image à la taille disponible
      ),
      centerTitle: true, // Centrer le logo
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'calendar') {
              onCalendar();
            } else if (value == 'logout') {
              onLogout();
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: 'calendar',
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Calendrier'),
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Déconnexion'),
              ),
            ),
          ],
          child: CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
