import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app_flutter/core/constants/app_colors.dart';
import 'package:todo_app_flutter/core/utils/validators.dart';
import 'package:todo_app_flutter/data/models/task_model.dart';
import 'package:todo_app_flutter/data/services/add_edit_task_notifier.dart';
import 'package:todo_app_flutter/data/services/firestore_service.dart';
import 'package:todo_app_flutter/presentation/screens/build_text_field.dart';
import 'package:todo_app_flutter/presentation/widgets/input_decoration.dart';

class AddEditTaskScreen extends ConsumerWidget {
  final String? taskId;
  final DocumentSnapshot? taskData;

  const AddEditTaskScreen({super.key, this.taskId, this.taskData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addEditTaskProvider);
    final notifier = ref.read(addEditTaskProvider.notifier);
    final formKey = GlobalKey<FormState>();

    if (taskId != null && taskData != null && !state.initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.setInitialData(
          TaskModel.fromMap(taskId!, taskData!.data() as Map<String, dynamic>),
        );
      });
    }

    return state.isLoading
        ? const Center(child: CircularProgressIndicator(color: Colors.orange))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.textPrimary,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                taskId == null ? 'Add Task' : 'Edit Task',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
            ),
            body: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: AppColors.backgroundGradient,
              ),
              child: SingleChildScrollView(
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTextField(
                            controller: state.titleController,
                            label: 'Title',
                            validator: (value) => Validators.validateRequired(
                              value,
                              fieldName: 'Title',
                            ),
                          ),
                          const SizedBox(height: 12),
                          buildTextField(
                            controller: state.descController,
                            label: 'Description',
                          ),
                          const SizedBox(height: 12),
                          buildTextField(
                            controller: state.assignedController,
                            label: 'Assigned To',
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
                                      : DateFormat.yMMMd().format(
                                          state.dueDate!,
                                        ),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        state.dueDate ?? DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) {
                                    notifier.updateDueDate(picked);
                                  }
                                },
                              ),
                            ],
                          ),
                          CheckboxListTile(
                            title: const Text('Mark as Important'),
                            value: state.important,
                            onChanged: (v) =>
                                notifier.toggleImportant(v ?? false),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Subtasks',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          ...state.subtasks.asMap().entries.map((entry) {
                            final i = entry.key;
                            final subtask = entry.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: subtask.controller,
                                      decoration: customInputDecoration(
                                        'Subtask title',
                                      ),
                                    ),
                                  ),
                                  Checkbox(
                                    value: subtask.completed,
                                    onChanged: (value) {
                                      notifier.updateSubtask(
                                        i,
                                        subtask.copyWith(
                                          completed: value ?? false,
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => notifier.removeSubtask(i),
                                  ),
                                ],
                              ),
                            );
                          }),
                          TextButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Add Subtask'),
                            onPressed: () => notifier.addSubtask(),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.textPrimary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Save Task',
                                style: TextStyle(color: AppColors.card),
                              ),
                              onPressed: () async {
                                if (!formKey.currentState!.validate()) return;
                                final updatedSubtasks = state.subtasks.map((s) {
                                  return s.copyWith(
                                    title: s.controller.text.trim(),
                                  );
                                }).toList();
                                final task = TaskModel(
                                  id: taskId,
                                  title: state.titleController.text.trim(),
                                  description: state.descController.text.trim(),
                                  assignedTo: state.assignedController.text
                                      .trim(),
                                  dueDate: state.dueDate,
                                  important: state.important,
                                  completed: taskData?['completed'] ?? false,
                                  subtasks: updatedSubtasks,
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
