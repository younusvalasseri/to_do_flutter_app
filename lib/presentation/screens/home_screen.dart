import 'package:flutter/material.dart';
import 'package:todo_app_flutter/presentation/screens/add_edit_task_screen.dart';
import 'package:todo_app_flutter/presentation/screens/task_list_screen.dart';
import 'package:todo_app_flutter/presentation/widgets/stats_section.dart';
import 'package:todo_app_flutter/presentation/widgets/search_bar.dart';

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
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          StatsSection(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() => _selectedFilter = filter);
            },
          ),
          TaskSearchBar(
            onSearchChanged: (query) {
              setState(() => _searchQuery = query.trim().toLowerCase());
            },
          ),
          Expanded(
            child: TaskList(searchQuery: _searchQuery, filter: _selectedFilter),
          ),
        ],
      ),
    );
  }
}
