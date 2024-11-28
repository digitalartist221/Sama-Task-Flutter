class Task {
  final String id; // Optionnel, pour identifier le document Firestore
  final String name;
  final String description;
  final String status;
  final String priority;
  final String dueDate;
  final DateTime createdAt;
  final String? assignedTo;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.priority,
    required this.dueDate,
    required this.createdAt,
    this.assignedTo,
  });

  // Convertit un document Firestore en objet Task
  factory Task.fromFirestore(String id, Map<String, dynamic> data) {
    return Task(
      id: id,
      name: data['name'] ?? 'Unnamed Task',
      description: data['description'] ?? '',
      status: data['status'] ?? 'Non terminé',
      priority: data['priority'] ?? 'Low',
      dueDate: data['due_date'] ?? '',
      createdAt: (data['created_at']).toDate(),
      assignedTo: data['assigned_to'],
    );
  }

  // Convertit un objet Task en document Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'status': status,
      'priority': priority,
      'due_date': dueDate,
      'created_at': createdAt,
      'assigned_to': assignedTo,
    };
  }
}
