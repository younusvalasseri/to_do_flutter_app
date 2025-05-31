import 'package:flutter/material.dart';
import 'package:todo_app_flutter/presentation/widgets/input_decoration.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String label,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    decoration: customInputDecoration(label),
    validator: validator,
  );
}
