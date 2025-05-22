import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskRepository {
  final CollectionReference tasksRef = FirebaseFirestore.instance.collection(
    'tasks',
  );

  /// Get all tasks with optional search query
  Stream<List<TaskModel>> getTasks({String searchQuery = ''}) {
    if (searchQuery.isNotEmpty) {
      return tasksRef
          .orderBy('title')
          .startAt([searchQuery])
          .endAt(['$searchQuery\uf8ff'])
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => TaskModel.fromFirestore(doc))
                .toList(),
          );
    } else {
      return tasksRef.snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList(),
      );
    }
  }

  /// Add a new task
  Future<void> addTask(TaskModel task) async {
    final newDoc = tasksRef.doc();
    await newDoc.set(task.toMap(newDoc.id));
  }

  /// Update existing task
  Future<void> updateTask(TaskModel task) async {
    await tasksRef.doc(task.id).update(task.toMap(task.id));
  }

  /// Delete task
  Future<void> deleteTask(String taskId) async {
    await tasksRef.doc(taskId).delete();
  }

  /// Mark task as completed or pending
  Future<void> toggleCompletion(String taskId, bool isCompleted) async {
    await tasksRef.doc(taskId).update({'isCompleted': isCompleted});
  }

  /// Mark task as important or not
  Future<void> toggleImportant(String taskId, bool isImportant) async {
    await tasksRef.doc(taskId).update({'isImportant': isImportant});
  }
}
