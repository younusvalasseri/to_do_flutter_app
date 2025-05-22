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
  final List<SubTask> subtasks;

  AddEditTaskState({
    required this.titleController,
    required this.descController,
    required this.assignedController,
    required this.dueDate,
    required this.important,
    required this.subtasks,
  });

  AddEditTaskState copyWith({
    DateTime? dueDate,
    bool? important,
    List<SubTask>? subtasks,
  }) {
    return AddEditTaskState(
      titleController: titleController,
      descController: descController,
      assignedController: assignedController,
      dueDate: dueDate ?? this.dueDate,
      important: important ?? this.important,
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
    state.titleController.text = task.title;
    state.descController.text = task.description ?? '';
    state.assignedController.text = task.assignedTo ?? '';
    state = state.copyWith(
      dueDate: task.dueDate,
      important: task.important,
      subtasks: task.subtasks,
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
