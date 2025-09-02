import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class WeeklyCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const WeeklyCalendar(
      {super.key, required this.selectedDate, required this.onDateSelected});

  @override
  State<WeeklyCalendar> createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  DateTime today = DateTime.now()
      .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

  String getRelativeDateText() {
    if (widget.selectedDate.isAtSameMomentAs(today)) {
      return "Today";
    } else if (widget.selectedDate.isBefore(today)) {
      return "Past";
    } else {
      return "Future";
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime startDate = today.subtract(const Duration(days: 3));
    final List<DateTime> weekDates = List.generate(
      7,
      (index) => startDate.add(Duration(days: index)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('dd MMMM yyyy').format(widget.selectedDate),
          style: const TextStyle(fontSize: 14, color: Color(0xFF686777)),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              getRelativeDateText(),
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            getRelativeDateText() == "Today"
                ? const Text(
                    "0/3 Tasks Completed",
                    style: TextStyle(fontSize: 14, color: Color(0xFF686777)),
                  )
                : const SizedBox(),
          ],
        ),
        const SizedBox(height: 16),
        // Calendar Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weekDates.map((date) {
            final bool isSelected = date.isAtSameMomentAs(widget.selectedDate);
            final bool isToday = date.isAtSameMomentAs(today);

            return GestureDetector(
              onTap: () {
                setState(() {
                  //widget.selectedDate = date;
                  widget.onDateSelected(date);
                });
              },
              child: Column(
                children: [
                  Text(
                    DateFormat('E').format(date).toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd').format(date),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.blue
                          : isToday
                              ? Colors.green
                              : Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isSelected)
                    Container(
                      height: 2,
                      width: 20,
                      color: Colors.blue,
                    ),
                ],
              ),
            );
          }).toList(),
        ),
        const Divider(thickness: 1, color: Colors.grey),
      ],
    );
  }
}
