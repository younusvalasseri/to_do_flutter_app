// lib/presentation/widgets/search_bar.dart

import 'package:flutter/material.dart';

class TaskSearchBar extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;

  const TaskSearchBar({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: onSearchChanged,
      ),
    );
  }
}
