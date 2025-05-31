import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_flutter/data/models/subtask_model.dart';
import 'package:todo_app_flutter/data/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_flutter/data/services/firestore_service.dart';

class AddEditTaskState {
  final bool isLoading;
  final TextEditingController titleController;
  final TextEditingController descController;
  final TextEditingController assignedController;
  final DateTime? dueDate;
  final bool important;
  final bool initialized;
  final List<SubTaskModel> subtasks;

  AddEditTaskState({
    this.isLoading = false,
    required this.titleController,
    required this.descController,
    required this.assignedController,
    required this.dueDate,
    required this.important,
    this.initialized = false,
    required this.subtasks,
  });

  AddEditTaskState copyWith({
    bool? isLoading,
    TextEditingController? titleController,
    TextEditingController? descController,
    TextEditingController? assignedController,
    DateTime? dueDate,
    bool? important,
    bool? initialized,
    List<SubTaskModel>? subtasks,
  }) {
    return AddEditTaskState(
      isLoading: isLoading ?? this.isLoading,
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

  Future<void> saveTask({
    required bool isNew,
    required TaskModel task,
    required VoidCallback onSuccess,
  }) async {
    state = state.copyWith(isLoading: true);
    final service = FirestoreService();

    try {
      if (isNew) {
        await service.addTask(task);
      } else {
        await service.updateTask(task);
      }
      onSuccess();
    } catch (e) {
      // handle errors if needed
    } finally {
      state = state.copyWith(isLoading: false);
    }
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
    final newSubtask = SubTaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '',
      completed: true,
    );
    state = state.copyWith(subtasks: [...state.subtasks, newSubtask]);
  }

  void updateSubtask(int index, SubTaskModel updated) {
    final updatedList = [...state.subtasks];
    updatedList[index] = updated;
    state = state.copyWith(subtasks: updatedList);
  }

  void removeSubtask(int index) {
    final updatedList = [...state.subtasks]..removeAt(index);
    state = state.copyWith(subtasks: updatedList);
  }

  void updateSubtaskTitleOnly(int index, String title) {
    final current = state.subtasks[index];
    current.controller.text = title;
    current.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: title.length),
    );
    final updated = current.copyWith(title: title);
    final updatedList = [...state.subtasks];
    updatedList[index] = updated;
    state = state.copyWith(subtasks: updatedList);
  }
}

final addEditTaskProvider =
    NotifierProvider<AddEditTaskNotifier, AddEditTaskState>(
      () => AddEditTaskNotifier(),
    );
