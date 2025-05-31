// home_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_flutter/core/constants/app_colors.dart';
import 'package:todo_app_flutter/data/services/home_screen_providers.dart';
import 'package:todo_app_flutter/presentation/widgets/stats_section.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(taskFilterProvider);

    return AppBar(
      backgroundColor: Colors.black,
      title: const Text(
        'To-Do List',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      ),
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
