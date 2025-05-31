import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_flutter/data/models/task_model.dart';
import 'package:todo_app_flutter/presentation/widgets/stats_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Filter state provider
final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);

// Search query state provider
final taskSearchProvider = StateProvider<String>((ref) => '');

final selectedDateProvider = StateProvider<DateTime?>((ref) => null);

final isTaskListLoadingProvider = Provider<bool>((ref) {
  final taskListAsync = ref.watch(taskListProvider);
  return taskListAsync is AsyncLoading;
});

final taskListProvider = FutureProvider<List<TaskModel>>((ref) async {
  final searchQuery = ref.watch(taskSearchProvider);
  final filter = ref.watch(taskFilterProvider);
  final selectedDate = ref.watch(selectedDateProvider);

  Query query = FirebaseFirestore.instance.collection('tasks');

  // Apply date filter
  if (selectedDate != null) {
    final start = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final end = start.add(const Duration(days: 1));
    query = query
        .where('dueDate', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('dueDate', isLessThan: Timestamp.fromDate(end));
  }

  // Apply filter (Pending, Completed, Important)
  switch (filter) {
    case TaskFilter.pending:
      query = query.where('isCompleted', isEqualTo: false);
      break;
    case TaskFilter.completed:
      query = query.where('isCompleted', isEqualTo: true);
      break;
    case TaskFilter.important:
      query = query.where('isImportant', isEqualTo: true);
      break;
    case TaskFilter.all:
      break;
  }

  final snapshot = await query.get();
  final tasks = snapshot.docs
      .map(
        (doc) => TaskModel.fromMap(doc.id, doc.data() as Map<String, dynamic>),
      )
      .toList();

  // Apply search filter
  if (searchQuery.isNotEmpty) {
    return tasks
        .where(
          (task) =>
              task.title.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  return tasks;
});
