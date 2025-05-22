import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_flutter/core/constants/app_colors.dart';
import 'package:todo_app_flutter/data/services/home_screen_providers.dart';
import 'package:todo_app_flutter/presentation/screens/add_edit_task_screen.dart';
import 'package:todo_app_flutter/presentation/screens/task_list_screen.dart';
import 'package:todo_app_flutter/presentation/widgets/search_bar.dart';
import 'package:todo_app_flutter/presentation/widgets/stats_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(taskSearchProvider);
    final selectedFilter = ref.watch(taskFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ChoiceChip(
              label: const Text('All Tasks'),
              selected: selectedFilter == TaskFilter.all,
              onSelected: (_) {
                ref.read(taskFilterProvider.notifier).state = TaskFilter.all;
              },
              selectedColor: AppColors.lightBlue,
              labelStyle: TextStyle(
                color: selectedFilter == TaskFilter.all
                    ? Colors.white
                    : Colors.black,
              ),
              backgroundColor: Colors.grey[200],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          StatsSection(
            selectedFilter: selectedFilter,
            onFilterChanged: (filter) {
              ref.read(taskFilterProvider.notifier).state = filter;
            },
          ),
          TaskSearchBar(
            onSearchChanged: (query) {
              ref.read(taskSearchProvider.notifier).state = query
                  .trim()
                  .toLowerCase();
            },
          ),
          Expanded(
            child: TaskList(searchQuery: searchQuery, filter: selectedFilter),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
          );
        },
        backgroundColor: AppColors.info,
        icon: const Icon(Icons.add_circle),
        label: const Text('Add'),
      ),
    );
  }
}
