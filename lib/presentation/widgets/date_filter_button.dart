import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFilterButton extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateChanged;

  const DateFilterButton({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                onDateChanged(picked);
              }
            },
            icon: const Icon(Icons.calendar_today),
            label: Text(
              selectedDate != null
                  ? DateFormat.yMMMd().format(selectedDate!)
                  : 'Filter',
            ),
          ),
          if (selectedDate != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => onDateChanged(null),
            ),
        ],
      ),
    );
  }
}
