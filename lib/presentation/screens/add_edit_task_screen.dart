import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app_flutter/core/utils/validators.dart';
import 'package:todo_app_flutter/data/models/task_model.dart';
import 'package:todo_app_flutter/data/services/add_edit_task_notifier.dart';
import 'package:todo_app_flutter/data/services/firestore_service.dart';

class AddEditTaskScreen extends ConsumerWidget {
  final String? taskId;
  final DocumentSnapshot? taskData;

  const AddEditTaskScreen({super.key, this.taskId, this.taskData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addEditTaskProvider);
    final notifier = ref.read(addEditTaskProvider.notifier);

    if (taskId != null && taskData != null && !state.initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final data = taskData!.data()! as Map<String, dynamic>;
        notifier.setInitialData(TaskModel.fromMap(data, id: taskId!));
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(taskId == null ? 'Add Task' : 'Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: state.titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                controller: state.descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: state.assignedController,
                decoration: const InputDecoration(labelText: 'Assigned To'),
                validator: (value) => Validators.validateRequired(
                  value,
                  fieldName: 'Assigned To',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      state.dueDate == null
                          ? 'Select Due Date'
                          : DateFormat.yMMMd().format(state.dueDate!),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: state.dueDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) notifier.updateDueDate(picked);
                    },
                  ),
                ],
              ),
              CheckboxListTile(
                title: const Text('Mark as Important'),
                value: state.important,
                onChanged: (v) => notifier.toggleImportant(v ?? false),
              ),
              const SizedBox(height: 16),
              Text('Subtasks', style: Theme.of(context).textTheme.titleMedium),
              ...state.subtasks.asMap().entries.map((entry) {
                final i = entry.key;
                final subtask = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: subtask.title,
                        decoration: const InputDecoration(
                          hintText: 'Subtask title',
                        ),
                        onChanged: (value) {
                          notifier.updateSubtask(
                            i,
                            subtask.copyWith(title: value),
                          );
                        },
                      ),
                    ),
                    Checkbox(
                      value: subtask.completed,
                      onChanged: (value) {
                        notifier.updateSubtask(
                          i,
                          subtask.copyWith(completed: value ?? false),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => notifier.removeSubtask(i),
                    ),
                  ],
                );
              }).toList(),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Subtask'),
                onPressed: () => notifier.addSubtask(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                child: const Text('Save Task'),
                onPressed: () async {
                  final task = TaskModel(
                    id: taskId,
                    title: state.titleController.text.trim(),
                    description: state.descController.text.trim(),
                    assignedTo: state.assignedController.text.trim(),
                    dueDate: state.dueDate,
                    important: state.important,
                    completed: taskData?['completed'] ?? false,
                    subtasks: state.subtasks,
                  );

                  final service = FirestoreService();
                  if (taskId == null) {
                    await service.addTask(task);
                  } else {
                    await service.updateTask(task);
                  }

                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
