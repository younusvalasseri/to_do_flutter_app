import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_flutter/presentation/screens/add_edit_task_screen.dart';
import 'package:todo_app_flutter/presentation/widgets/stats_section.dart';

class TaskList extends StatelessWidget {
  final String searchQuery;
  final TaskFilter filter;

  const TaskList({super.key, required this.searchQuery, required this.filter});

  DateTime? parseDueDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String && value.isNotEmpty) return DateTime.tryParse(value);
    return null;
  }

  bool matchesFilter(Map<String, dynamic> task) {
    switch (filter) {
      case TaskFilter.completed:
        return task['completed'] == true;
      case TaskFilter.pending:
        return task['completed'] != true;
      case TaskFilter.important:
        return task['important'] == true;
      case TaskFilter.all:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading tasks'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs.where((doc) {
          final task = doc.data() as Map<String, dynamic>;
          final title = task['title']?.toString().toLowerCase() ?? '';
          return title.contains(searchQuery) && matchesFilter(task);
        }).toList();

        if (docs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'You don’t have any tasks yet.\nStart adding tasks and manage your time effectively.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final task = doc.data() as Map<String, dynamic>;
            final dueDate = parseDueDate(task['dueDate']);

            return ListTile(
              title: Text(task['title'] ?? 'No Title'),
              subtitle: Text(
                dueDate != null
                    ? DateFormat.yMMMd().format(dueDate)
                    : 'No Due Date',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (task['completed'] == true)
                    const Icon(Icons.check_circle, color: Colors.green),
                  Icon(
                    task['important'] == true ? Icons.star : Icons.star_border,
                    color: task['important'] == true ? Colors.orange : null,
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddEditTaskScreen(
                              taskId: doc.id,
                              taskData: doc,
                            ),
                          ),
                        );
                      } else if (value == 'delete') {
                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(doc.id)
                            .delete();
                      } else if (value == 'complete') {
                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(doc.id)
                            .update({'completed': true});
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                      if (task['completed'] != true)
                        const PopupMenuItem(
                          value: 'complete',
                          child: Text('Mark as Completed'),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
