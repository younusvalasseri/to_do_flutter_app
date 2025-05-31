// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:todo_app_flutter/data/models/subtask_model.dart';

// class SubTaskNotifier extends StateNotifier<List<SubTaskModel>> {
//   SubTaskNotifier() : super([]);

//   void addSubtask(SubTaskModel subtask) {
//     state = [...state, subtask];
//   }

//   void updateSubtask(int index, SubTaskModel updated) {
//     state = [
//       for (int i = 0; i < state.length; i++)
//         if (i == index) updated else state[i],
//     ];
//   }

//   // 👇 Add this here
//   void updateSubtaskTitleOnly(int index, String title) {
//     final current = state[index];
//     current.controller.text = title; // optional, because user typed it
//     current.controller.selection = TextSelection.fromPosition(
//       TextPosition(offset: title.length),
//     );
//     state[index] = current.copyWith(title: title);
//   }
// }
