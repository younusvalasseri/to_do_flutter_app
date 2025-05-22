import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String assignedTo;
  final DateTime dueDate;
  final bool isCompleted;
  final bool isImportant;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.dueDate,
    this.isCompleted = false,
    this.isImportant = false,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      assignedTo: data['assignedTo'] ?? '',
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'] ?? false,
      isImportant: data['isImportant'] ?? false,
    );
  }

  Map<String, dynamic> toMap(String id) {
    return {
      'title': title,
      'description': description,
      'assignedTo': assignedTo,
      'dueDate': Timestamp.fromDate(dueDate),
      'isCompleted': isCompleted,
      'isImportant': isImportant,
    };
  }
}
