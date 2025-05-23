import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_flutter/core/constants/app_colors.dart';
import 'package:todo_app_flutter/data/services/add_edit_task_notifier.dart';
import 'package:todo_app_flutter/data/services/home_screen_providers.dart';
import 'package:todo_app_flutter/presentation/screens/add_edit_task_screen.dart';
import 'package:todo_app_flutter/presentation/screens/task_list_screen.dart';
import 'package:todo_app_flutter/presentation/widgets/home_app_bar.dart';
import 'package:todo_app_flutter/presentation/widgets/search_bar.dart';
import 'package:todo_app_flutter/presentation/widgets/stats_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(taskSearchProvider);
    final selectedFilter = ref.watch(taskFilterProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    return Scaffold(
      //App bar withtitle and All tasks button
      appBar: const HomeAppBar(),
      body: Column(
        children: [
          //Pending Completed Important buttons
          StatsSection(
            selectedFilter: selectedFilter,
            onFilterChanged: (filter) {
              ref.read(taskFilterProvider.notifier).state = filter;
            },
          ),
          //search bar
          TaskSearchBar(
            onSearchChanged: (query) {
              ref.read(taskSearchProvider.notifier).state = query;
            },
            selectedDate: selectedDate,
            onDateChanged: (pickedDate) {
              ref.read(selectedDateProvider.notifier).state = pickedDate;
            },
          ),

          //Task list
          Expanded(
            child: TaskList(searchQuery: searchQuery, filter: selectedFilter),
          ),
        ],
      ),
      //Add tasks
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.invalidate(addEditTaskProvider);
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
