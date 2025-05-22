import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_flutter/core/constants/app_colors.dart';

enum TaskFilter { all, pending, completed, important }

class StatsSection extends StatelessWidget {
  final TaskFilter selectedFilter;
  final ValueChanged<TaskFilter> onFilterChanged;

  const StatsSection({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        var tasks = snapshot.data!.docs;
        int completed = tasks.where((task) => task['completed'] == true).length;
        int pending = tasks.length - completed;
        int important = tasks.where((task) => task['important'] == true).length;

        Widget buildFilterChip(String label, TaskFilter filter, int count) {
          return ChoiceChip(
            label: Text('$label: $count'),
            selected: selectedFilter == filter,
            onSelected: (_) => onFilterChanged(filter),
            selectedColor: AppColors.lightBlue,
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 8.0,
            children: [
              buildFilterChip('Pending', TaskFilter.pending, pending),
              buildFilterChip('Completed', TaskFilter.completed, completed),
              buildFilterChip('Important', TaskFilter.important, important),
            ],
          ),
        );
      },
    );
  }
}
