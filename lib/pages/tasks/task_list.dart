import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task/pages/auth/home_page.dart';
import 'package:intl/intl.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user's email
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    // Return an empty container if the user is not authenticated
    if (currentUserEmail == null) {
      return SomethingWentWrong(); // Or show a login screen
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .where('assigned_to',
              isEqualTo: currentUserEmail) // Filter by assigned_to
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

            // Get the priority and set the color
            String priority = data['priority'] ?? 'Non spécifiée';
            Color cardColor = _getPriorityColor(priority);
            // Vérifier si le champ 'due_date' existe et est un timestamp
            String formattedDate;
            if (data['due_date'] != null && data['due_date'] is int) {
              // Convertir le timestamp en DateTime
              DateTime dateTime =
                  DateTime.fromMillisecondsSinceEpoch(data['due_date'] * 1000);
              // Formater la date
              formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
            } else {
              formattedDate = 'Non spécifiée';
            }
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color:
                  cardColor, // Définir la couleur de la carte en fonction de la priorité
              child: ListTile(
                title: Text(
                  data['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.black, // Définir la couleur du texte à noir
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.0),
                    Text(
                      "Description: ${data['description'] ?? 'Non spécifiée'}",
                      style: TextStyle(
                        color:
                            Colors.black, // Définir la couleur du texte à noir
                      ),
                    ),
                    Text(
                      "Date limite: $formattedDate",
                      style: TextStyle(
                        color:
                            Colors.black, // Définir la couleur du texte à noir
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Bouton pour supprimer la tâche
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteTask(context, document.reference);
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Faible':
        return Colors.green.shade200; // Light green for 'Faible'
      case 'Moyenne':
        return Colors.orange.shade200; // Light orange for 'Moyenne'
      case 'Élevée':
        return Colors.red.shade200; // Light red for 'Élevée'
      default:
        return Colors.grey.shade200; // Grey for unknown or unspecified
    }
  }

  void _deleteTask(BuildContext context, DocumentReference taskRef) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer la tâche'),
          content: Text('Êtes-vous sûr de vouloir supprimer cette tâche ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage()), // Changez `AddTaskForm` selon votre page
                );
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                taskRef.delete().then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tâche supprimée.')),
                  );
                }).catchError((error) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur : $error')),
                  );
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage()), // Changez `AddTaskForm` selon votre page
                );
              },
              child: Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Une erreur est survenue.')),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
