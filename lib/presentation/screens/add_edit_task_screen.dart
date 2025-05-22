import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_flutter/core/utils/validators.dart';
import 'package:todo_app_flutter/data/models/subtask_model.dart';
import 'package:todo_app_flutter/data/models/task_model.dart';
import 'package:todo_app_flutter/data/services/firestore_service.dart';

class AddEditTaskScreen extends StatefulWidget {
  final String? taskId;
  final DocumentSnapshot? taskData;

  const AddEditTaskScreen({super.key, this.taskId, this.taskData});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  List<SubTask> _subtasks = [];
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _assignedController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  DateTime? _dueDate;
  bool _important = false;

  @override
  void initState() {
    super.initState();

    if (widget.taskData != null) {
      final data = widget.taskData!.data()! as Map<String, dynamic>;

      _titleController.text = data['title'] ?? '';
      _descController.text = data['description'] ?? '';
      _assignedController.text = data['assignedTo'] ?? '';

      // ---- robust parsing for either Timestamp or String ----
      final dueField = data['dueDate'];
      if (dueField is Timestamp) {
        _dueDate = dueField.toDate();
      } else if (dueField is String && dueField.isNotEmpty) {
        _dueDate = DateTime.tryParse(dueField);
      }

      _important = data['important'] ?? false;
      final subtasksData = data['subtasks'] as List<dynamic>? ?? [];
      _subtasks = subtasksData.map((e) => SubTask.fromMap(e)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskId == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ------------ Title ------------
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Enter title' : null,
              ),

              // ---------- Description --------
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),

              // ---------- Assigned To --------
              TextFormField(
                controller: _assignedController,
                decoration: const InputDecoration(labelText: 'Assigned To'),
                validator: (value) => Validators.validateRequired(
                  value,
                  fieldName: 'Assigned To',
                ),
              ),

              const SizedBox(height: 12),

              // ----------- Due-date picker -----------
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _dueDate == null
                          ? 'Select Due Date'
                          : DateFormat.yMMMd().format(_dueDate!),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _dueDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _dueDate = picked);
                    },
                  ),
                ],
              ),

              // ----------- Important flag ------------
              CheckboxListTile(
                title: const Text('Mark as Important'),
                value: _important,
                onChanged: (v) => setState(() => _important = v ?? false),
              ),
              const SizedBox(height: 16),
              Text('Subtasks', style: Theme.of(context).textTheme.titleMedium),

              ..._subtasks.map((subtask) {
                final index = _subtasks.indexOf(subtask);
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: subtask.title,
                        decoration: const InputDecoration(
                          hintText: 'Subtask title',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _subtasks[index] = subtask.copyWith(title: value);
                          });
                        },
                      ),
                    ),
                    Checkbox(
                      value: subtask.completed,
                      onChanged: (value) {
                        setState(() {
                          _subtasks[index] = subtask.copyWith(
                            completed: value ?? false,
                          );
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() => _subtasks.removeAt(index));
                      },
                    ),
                  ],
                );
              }),

              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Subtask'),
                onPressed: () {
                  setState(() {
                    _subtasks.add(
                      SubTask(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: '',
                      ),
                    );
                  });
                },
              ),

              const SizedBox(height: 24),

              // --------------- Save ------------------
              ElevatedButton(
                child: const Text('Save Task'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newTask = TaskModel(
                      id: widget.taskId,
                      title: _titleController.text.trim(),
                      description: _descController.text.trim(),
                      assignedTo: _assignedController.text.trim(),
                      dueDate: _dueDate,
                      important: _important,
                      completed: widget.taskId == null
                          ? false
                          : (widget.taskData?['completed'] ?? false),
                      subtasks: _subtasks,
                    );

                    if (widget.taskId == null) {
                      await _firestoreService.addTask(newTask);
                    } else {
                      await _firestoreService.updateTask(newTask);
                    }

                    if (context.mounted) Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
