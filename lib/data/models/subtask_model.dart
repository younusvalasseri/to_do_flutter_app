class SubTask {
  final String id;
  final String title;
  final bool completed;

  SubTask({required this.id, required this.title, this.completed = false});

  factory SubTask.fromMap(Map<String, dynamic> map) {
    return SubTask(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      completed: map['completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'completed': completed};
  }

  SubTask copyWith({String? title, bool? completed}) {
    return SubTask(
      id: id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
