import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_flutter/core/constants/app_colors.dart';
import 'package:todo_app_flutter/core/constants/app_styles.dart';

class TaskDetailsModal extends StatelessWidget {
  final Map<String, dynamic> task;

  const TaskDetailsModal({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final dueDate = task['dueDate'] is Timestamp
        ? (task['dueDate'] as Timestamp).toDate()
        : null;

    final subtasks = (task['subtasks'] as List?) ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(task['title'] ?? 'No Title', style: AppStyles.headline2),
            const SizedBox(height: 8),
            if (dueDate != null)
              Text('Due: ${DateFormat.yMMMd().format(dueDate)}'),
            const SizedBox(height: 8),
            if (task['description'] != null &&
                task['description'].toString().isNotEmpty)
              Text(task['description'], style: AppStyles.subtitle2),
            const SizedBox(height: 16),
            if (subtasks.isNotEmpty) ...[
              const Text('Sub-Tasks:', style: AppStyles.subtitle1),
              const SizedBox(height: 8),
              ...subtasks.map(
                (sub) => Row(
                  children: [
                    Icon(
                      sub['completed'] == true
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(sub['title'] ?? '')),
                  ],
                ),
              ),
            ] else
              const Text('No sub-tasks added.', style: AppStyles.subtitle2),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
