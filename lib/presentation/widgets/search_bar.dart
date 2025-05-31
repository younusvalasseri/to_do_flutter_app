// lib/presentation/widgets/search_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_flutter/data/services/home_screen_providers.dart';
import 'package:todo_app_flutter/presentation/widgets/date_filter_button.dart';

class TaskSearchBar extends ConsumerWidget {
  final ValueChanged<String> onSearchChanged;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateChanged;

  const TaskSearchBar({
    super.key,
    required this.onSearchChanged,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: onSearchChanged,
            ),
          ),
          const SizedBox(width: 8),
          DateFilterButton(
            selectedDate: selectedDate,
            onDateChanged: (pickedDate) {
              ref.read(selectedDateProvider.notifier).state = pickedDate;
            },
          ),
        ],
      ),
    );
  }
}
