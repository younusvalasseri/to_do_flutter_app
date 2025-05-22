import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_flutter/presentation/widgets/stats_section.dart';

// Filter state provider
final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);

// Search query state provider
final taskSearchProvider = StateProvider<String>((ref) => '');
