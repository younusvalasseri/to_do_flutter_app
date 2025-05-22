import 'package:cloud_firestore/cloud_firestore.dart';
import 'subtask_model.dart';

class TaskModel {
  final String? id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool completed;
  final bool important;
  final String? assignedTo;
  final List<SubTask> subtasks;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.completed = false,
    this.important = false,
    this.assignedTo,
    this.subtasks = const [],
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'],
      dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
      completed: data['completed'] ?? false,
      important: data['important'] ?? false,
      assignedTo: data['assignedTo'],
      subtasks:
          (data['subtasks'] as List<dynamic>?)
              ?.map((item) => SubTask.fromMap(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'completed': completed,
      'important': important,
      'assignedTo': assignedTo,
      'subtasks': subtasks.map((e) => e.toMap()).toList(),
    };
  }

  TaskModel copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    bool? completed,
    bool? important,
    String? assignedTo,
    List<SubTask>? subtasks,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
      important: important ?? this.important,
      assignedTo: assignedTo ?? this.assignedTo,
      subtasks: subtasks ?? this.subtasks,
    );
  }
}
