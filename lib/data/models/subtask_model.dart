import 'package:flutter/material.dart';

class SubTaskModel {
  final String id;
  final String title;
  final bool completed;
  final TextEditingController controller;

  SubTaskModel({
    required this.id,
    required this.title,
    required this.completed,
    TextEditingController? controller,
  }) : controller = controller ?? TextEditingController(text: title);

  SubTaskModel copyWith({
    String? id,
    String? title,
    bool? completed,
    TextEditingController? controller,
  }) {
    return SubTaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      controller: controller ?? this.controller,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'completed': completed};
  }

  factory SubTaskModel.fromMap(Map<String, dynamic> map) {
    return SubTaskModel(
      id: map['id'],
      title: map['title'],
      completed: map['completed'],
    );
  }
}
