import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task/models/appColor.dart'; // Importer le fichier des couleurs de l'application

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final EventController _eventController = EventController();

  @override
  void initState() {
    super.initState();
    _fetchTasksFromFirebase();
  }

  void _fetchTasksFromFirebase() async {
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    if (currentUserEmail != null) {
      FirebaseFirestore.instance
          .collection('tasks')
          .where('assigned_to', isEqualTo: currentUserEmail)
          .get()
          .then((snapshot) {
        List<CalendarEventData> events = [];
        for (var doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data();
          DateTime taskDateTime = (data['due_date'] as Timestamp).toDate();
          Color priorityColor = _getPriorityColor(data['priority']);

          events.add(
            CalendarEventData(
              title: data['name'],
              description: data['description'] ?? "Pas de description",
              date: taskDateTime,
              startTime: taskDateTime,
              endTime: taskDateTime.add(Duration(hours: 1)),
              color: priorityColor,
            ),
          );
        }
        _eventController.addAll(events);
        setState(() {});
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors du chargement : $error")),
        );
      });
    }
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

  void _addEventToFirebase(
      String title, String description, DateTime date, String priority) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').add({
        'name': title,
        'description': description,
        'assigned_to': FirebaseAuth.instance.currentUser?.email,
        'due_date': Timestamp.fromDate(date),
        'priority': priority,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tâche ajoutée avec succès")),
      );

      _fetchTasksFromFirebase();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'ajout : $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Calendrier"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddEventDialog,
          ),
        ],
      ),
      body: MonthView(
        controller: _eventController,
      ),
    );
  }

  void _showAddEventDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    String priority = 'Moyenne';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter une tâche"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Titre"),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              DropdownButton<String>(
                value: priority,
                onChanged: (String? newValue) {
                  setState(() {
                    priority = newValue!;
                  });
                },
                items: <String>['Faible', 'Moyenne', 'Élevée']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                _addEventToFirebase(
                  titleController.text,
                  descriptionController.text,
                  DateTime.now(),
                  priority,
                );
                Navigator.pop(context);
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }
}
