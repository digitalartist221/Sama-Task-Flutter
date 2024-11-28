import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:task/pages/auth/home_page.dart';
import 'package:task/pages/auth/login_page.dart';
import 'package:task/pages/tasks/add_task_form.dart';
import 'package:task/pages/tasks/calendar_page.dart';

import 'package:calendar_view/calendar_view.dart';

import 'package:task/models/appColor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Attente de l'initialisation de Firebase
  await Firebase.initializeApp(
    options: kIsWeb
        ? FirebaseOptions(
            apiKey:
                "AIzaSyDNcpbYPTBnc4iJKeb27Q3aTsUxsRrCVXE", // Remplacé par votre nouvelle clé API
            authDomain:
                "task-manager-82d20.firebaseapp.com", // Remplacé par votre nouveau domaine d'authentification
            projectId:
                "task-manager-82d20", // Remplacé par votre nouveau ID de projet
            storageBucket:
                "task-manager-82d20.appspot.com", // Remplacé par votre nouveau bucket de stockage
            messagingSenderId:
                "339944089043", // Remplacé par votre nouveau ID de messagerie
            appId:
                "1:339944089043:web:d9c0b6c9e154d2800c1f9f", // Remplacé par votre nouveau ID d'application
          )
        : null, // Configuration par défaut pour Android/iOS
  );
  runApp(
    CalendarControllerProvider(
      controller: EventController(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.accentOrange,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: AppColors.textPrimary),
          bodyText2: TextStyle(color: AppColors.textSecondary),
          headline6: TextStyle(color: AppColors.textPrimary),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.accentOrange,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: AppColors.accentBlue,
          textTheme: ButtonTextTheme.primary,
        ),
        appBarTheme: AppBarTheme(
          color: AppColors.backgroundDark,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
      ),
      routes: {
        '/home': (context) => HomePage(),
        '/addTask': (context) => AddTaskForm(),
        '/calendar': (context) => CalendarPage(),
        '/login': (context) => LoginPage(),
      },
      home: LoginPage(),
    );
  }
}
