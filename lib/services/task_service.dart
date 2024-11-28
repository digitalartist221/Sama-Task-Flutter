import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Ajouter une nouvelle tâche
  Future<void> addTask(Map<String, dynamic> task) async {
    try {
      await _db.collection('tasks').add(task);
    } catch (e) {
      print("Erreur lors de l'ajout de la tâche: $e");
    }
  }

  // Supprimer une tâche
  Future<void> deleteTask(String taskId) async {
    try {
      await _db.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print("Erreur lors de la suppression de la tâche: $e");
    }
  }

  // Mettre à jour une tâche
  Future<void> updateTask(String taskId, Map<String, dynamic> updates) async {
    try {
      await _db.collection('tasks').doc(taskId).update(updates);
    } catch (e) {
      print("Erreur lors de la mise à jour de la tâche: $e");
    }
  }

  // Récupérer les tâches assignées à l'utilisateur connecté
  Stream<List<Map<String, dynamic>>> getTasks() {
    String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    // Filtrer les tâches où l'email de l'utilisateur correspond au champ 'assigned_to'
    return _db
        .collection('tasks')
        .where('assigned_to',
            isEqualTo: userEmail) // Filtre par l'email de l'utilisateur
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'description': doc['description'],
          'status': doc['status'],
          'priority': doc['priority'],
          'due_date': doc['due_date'],
          'reminder': doc['reminder'],
          'category': doc['category'],
          'tags': doc['tags'],
          'assigned_to': doc['assigned_to'],
          'created_at': doc['created_at'],
        };
      }).toList();
    });
  }

  // Se déconnecter
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
