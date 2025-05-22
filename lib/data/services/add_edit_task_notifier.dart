import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_flutter/data/models/subtask_model.dart';
import 'package:todo_app_flutter/data/models/task_model.dart';
import 'package:flutter/material.dart';

class AddEditTaskState {
  final TextEditingController titleController;
  final TextEditingController descController;
  final TextEditingController assignedController;
  final DateTime? dueDate;
  final bool important;
  final bool initialized;
  final List<SubTask> subtasks;

  AddEditTaskState({
    required this.titleController,
    required this.descController,
    required this.assignedController,
    required this.dueDate,
    required this.important,
    this.initialized = false,
    required this.subtasks,
  });

  AddEditTaskState copyWith({
    TextEditingController? titleController,
    TextEditingController? descController,
    TextEditingController? assignedController,
    DateTime? dueDate,
    bool? important,
    bool? initialized,
    List<SubTask>? subtasks,
  }) {
    return AddEditTaskState(
      titleController: titleController ?? this.titleController,
      descController: descController ?? this.descController,
      assignedController: assignedController ?? this.assignedController,
      dueDate: dueDate ?? this.dueDate,
      important: important ?? this.important,
      initialized: initialized ?? this.initialized,
      subtasks: subtasks ?? this.subtasks,
    );
  }
}

class AddEditTaskNotifier extends Notifier<AddEditTaskState> {
  @override
  AddEditTaskState build() {
    return AddEditTaskState(
      titleController: TextEditingController(),
      descController: TextEditingController(),
      assignedController: TextEditingController(),
      dueDate: null,
      important: false,
      subtasks: [],
    );
  }

  void setInitialData(TaskModel task) {
    state = state.copyWith(
      titleController: TextEditingController(text: task.title),
      descController: TextEditingController(text: task.description),
      assignedController: TextEditingController(text: task.assignedTo),
      dueDate: task.dueDate,
      important: task.important,
      subtasks: task.subtasks,
      initialized: true,
    );
  }

  void updateDueDate(DateTime date) => state = state.copyWith(dueDate: date);

  void toggleImportant(bool value) => state = state.copyWith(important: value);

  void addSubtask() {
    final newSubtask = SubTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '',
    );
    state = state.copyWith(subtasks: [...state.subtasks, newSubtask]);
  }

  void updateSubtask(int index, SubTask updated) {
    final updatedList = [...state.subtasks];
    updatedList[index] = updated;
    state = state.copyWith(subtasks: updatedList);
  }

  void removeSubtask(int index) {
    final updatedList = [...state.subtasks]..removeAt(index);
    state = state.copyWith(subtasks: updatedList);
  }
}

final addEditTaskProvider =
    NotifierProvider<AddEditTaskNotifier, AddEditTaskState>(
      () => AddEditTaskNotifier(),
    );
