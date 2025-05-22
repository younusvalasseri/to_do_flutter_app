import 'package:flutter/material.dart';
import 'package:todo_app_flutter/core/constants/app_colors.dart';
import 'package:todo_app_flutter/presentation/screens/add_edit_task_screen.dart';
import 'package:todo_app_flutter/presentation/screens/task_list_screen.dart';
import 'package:todo_app_flutter/presentation/widgets/search_bar.dart';
import 'package:todo_app_flutter/presentation/widgets/stats_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  TaskFilter _selectedFilter = TaskFilter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ChoiceChip(
              label: const Text('All Tasks'),
              selected: _selectedFilter == TaskFilter.all,
              onSelected: (_) {
                setState(() => _selectedFilter = TaskFilter.all);
              },
              selectedColor: AppColors.lightBlue,
              labelStyle: TextStyle(
                color: _selectedFilter == TaskFilter.all
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
          //Pending/ completed/Important tasks
          StatsSection(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() => _selectedFilter = filter);
            },
          ),
          //search bar
          TaskSearchBar(
            onSearchChanged: (query) {
              setState(() => _searchQuery = query.trim().toLowerCase());
            },
          ),
          //task list
          Expanded(
            child: TaskList(searchQuery: _searchQuery, filter: _selectedFilter),
          ),
        ],
      ),

      // Floating Action Button with "Add" tasks
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
