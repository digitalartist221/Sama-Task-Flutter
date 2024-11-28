import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task/pages/auth/home_page.dart';
import 'package:intl/intl.dart'; // Ajouter dans pubspec.yaml

class AddTaskForm extends StatefulWidget {
  @override
  _AddTaskFormState createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();

  String? _priority; // Menu déroulant pour la sélection de priorité

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une tâche'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Retour à la page précédente
          },
        ),
      ),
      body: SingleChildScrollView(
        // Permet de faire défiler le formulaire sur de petits écrans
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            // Centrer le formulaire dans le corps de la page
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nom de la tâche',
                      prefixIcon: Icon(Icons.task), // Icône avant le texte
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom pour la tâche';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      prefixIcon:
                          Icon(Icons.description), // Icône avant le texte
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une description';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _priority,
                    items: ['Faible', 'Moyenne', 'Élevée']
                        .map((priority) => DropdownMenuItem(
                              value: priority,
                              child: Text(priority),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _priority = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Priorité',
                      prefixIcon:
                          Icon(Icons.priority_high), // Icône avant le texte
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez sélectionner une priorité';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _dueDateController,
                    decoration: InputDecoration(
                      labelText: 'Date limite',
                      prefixIcon:
                          Icon(Icons.date_range), // Icône avant le texte
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une date limite';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Format attendu : DD/MM/YYYY
                      DateTime parsedDate = DateFormat('dd/MM/yyyy')
                          .parse(_dueDateController.text);

                      // Convertir en Timestamp
                      Timestamp dueDateTimestamp =
                          Timestamp.fromDate(parsedDate);

                      if (_formKey.currentState!.validate()) {
                        FirebaseFirestore.instance.collection('tasks').add({
                          "name": _nameController.text,
                          "description": _descriptionController.text,
                          "status": "Non terminé",
                          "priority": _priority,
                          "due_date": dueDateTimestamp,
                          "created_at": Timestamp.now(),
                          "assigned_to":
                              FirebaseAuth.instance.currentUser?.email,
                        }).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Tâche ajoutée avec succès !')),
                          );
                          _nameController.clear();
                          _descriptionController.clear();
                          _dueDateController.clear();
                          setState(() {
                            _priority = null;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePage()), // Changez `AddTaskForm` selon votre page
                          );
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erreur : $error')),
                          );
                        });
                      }
                    },
                    child: Text('Ajouter une tâche'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
