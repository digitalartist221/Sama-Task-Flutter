import 'package:flutter/material.dart';
import 'package:task/pages/tasks/add_task_form.dart'; // Importez votre TaskForm ici

class BottomButton extends StatelessWidget {
  const BottomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Naviguer vers TaskForm lorsque le bouton est pressé
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddTaskForm()), // Changez `AddTaskForm` selon votre page
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFAB47BC), // Violet
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Ajouter une tâche',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
