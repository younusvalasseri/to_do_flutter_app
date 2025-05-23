import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_flutter/core/constants/app_colors.dart';
import 'package:todo_app_flutter/core/constants/app_styles.dart';
import 'package:todo_app_flutter/data/services/add_edit_task_notifier.dart';
import 'package:todo_app_flutter/data/services/firestore_service.dart';
import 'package:todo_app_flutter/data/services/home_screen_providers.dart';
import 'package:todo_app_flutter/presentation/screens/add_edit_task_screen.dart';
import 'package:todo_app_flutter/presentation/widgets/date_filter_button.dart';
import 'package:todo_app_flutter/presentation/widgets/stats_section.dart';
import 'package:todo_app_flutter/presentation/widgets/task_details_modal.dart';

class TaskList extends ConsumerWidget {
  final String searchQuery;
  final TaskFilter filter;

  const TaskList({super.key, required this.searchQuery, required this.filter});

  DateTime? parseDueDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String && value.isNotEmpty) return DateTime.tryParse(value);
    return null;
  }

  bool matchesFilter(Map<String, dynamic> task, TaskFilter filter) {
    switch (filter) {
      case TaskFilter.completed:
        return task['completed'] == true;
      case TaskFilter.pending:
        return task['completed'] != true;
      case TaskFilter.important:
        return task['important'] == true;
      case TaskFilter.all:
        return true;
    }
  }

  bool matchesDateFilter(DateTime? dueDate, DateTime? selectedDate) {
    if (selectedDate == null || dueDate == null) return true;
    return dueDate.year == selectedDate.year &&
        dueDate.month == selectedDate.month &&
        dueDate.day == selectedDate.day;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirestoreService firestoreService = FirestoreService();
    final selectedDate = ref.watch(selectedDateProvider);

    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getTaskStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading tasks'));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data!.docs.where((doc) {
                final task = doc.data() as Map<String, dynamic>;
                final title = task['title']?.toString().toLowerCase() ?? '';
                final dueDate = parseDueDate(task['dueDate']);

                return title.contains(searchQuery.toLowerCase()) &&
                    matchesFilter(task, filter) &&
                    matchesDateFilter(dueDate, selectedDate);
              }).toList();

              if (docs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      'You don’t have any tasks yet.\nStart adding tasks and manage your time effectively.',
                      style: AppStyles.subtitle2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final task = doc.data()! as Map<String, dynamic>;
                  final due = parseDueDate(task['dueDate']);

                  final Color cardColor = task['completed'] == true
                      ? AppColors.success.withOpacity(.12)
                      : task['important'] == true
                      ? AppColors.secondary.withOpacity(.10)
                      : Theme.of(context).cardColor;

                  return Hero(
                    tag: doc.id,
                    child: Card(
                      color: cardColor,
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            isScrollControlled: true,
                            builder: (_) => TaskDetailsModal(task: task),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              task['completed'] == true
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: AppColors.success,
                                      size: 28,
                                    )
                                  : const Icon(
                                      Icons.radio_button_unchecked,
                                      color: AppColors.card,
                                      size: 28,
                                    ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task['title'] ?? 'No Title',
                                      style: AppStyles.subtitle1.copyWith(
                                        decoration: task['completed'] == true
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      due != null
                                          ? DateFormat.yMMMd().format(due)
                                          : 'No Due Date',
                                      style: AppStyles.subtitle2.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                task['important'] == true
                                    ? Icons.star
                                    : Icons.star_border,
                                color: task['important'] == true
                                    ? AppColors.secondary
                                    : Colors.grey[400],
                              ),
                              const SizedBox(width: 4),
                              PopupMenuButton<String>(
                                splashRadius: 18,
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    ref.invalidate(addEditTaskProvider);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddEditTaskScreen(
                                          taskId: doc.id,
                                          taskData: doc,
                                        ),
                                      ),
                                    );
                                  } else if (value == 'delete') {
                                    await firestoreService.deleteTask(doc.id);
                                  } else if (value == 'complete') {
                                    await firestoreService.markTaskAsCompleted(
                                      doc.id,
                                    );
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                  if (task['completed'] != true)
                                    const PopupMenuItem(
                                      value: 'complete',
                                      child: Text('Mark as Completed'),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
