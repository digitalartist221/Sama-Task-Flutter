import 'package:flutter/material.dart';
import 'package:task/pages/auth/login_page.dart';
import 'package:task/pages/tasks/calendar_page.dart';
import 'package:task/pages/tasks/task_list.dart';
import 'package:task/pages/widgets/navbar.dart';
import 'package:task/pages/widgets/bottomButton.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(
        avatarUrl: 'https://via.placeholder.com/150',
        onCalendar: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CalendarPage()),
          );
        },
        onLogout: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        isHomePage: true, // Ajout du paramètre isHomePage
      ),
      body: Column(
        children: [Expanded(child: TaskList()), const BottomButton()],
      ),
    );
  }
}
