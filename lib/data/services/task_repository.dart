// import '../models/task_model.dart';
// import 'firestore_service.dart';

// class TaskRepository {
//   final FirestoreService _firestoreService = FirestoreService();

//   Stream<List<TaskModel>> getTasks({String searchQuery = ''}) {
//     return _firestoreService.getTasks(searchQuery: searchQuery);
//   }

//   Future<void> addTask(TaskModel task) {
//     return _firestoreService.addTask(task);
//   }

//   Future<void> updateTask(TaskModel task) {
//     return _firestoreService.updateTask(task);
//   }

//   Future<void> deleteTask(String taskId) {
//     return _firestoreService.deleteTask(taskId);
//   }

//   Future<void> toggleCompletion(String taskId, bool isCompleted) {
//     return _firestoreService.toggleCompletion(taskId, isCompleted);
//   }

//   Future<void> toggleImportant(String taskId, bool isImportant) {
//     return _firestoreService.toggleImportant(taskId, isImportant);
//   }
// }
