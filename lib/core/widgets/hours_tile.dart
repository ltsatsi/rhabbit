// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

import 'package:flutter/material.dart';

class HoursTile extends StatelessWidget {
  final int hours;
  final bool isSelected;
  const HoursTile({super.key, required this.hours, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Text(
          isSelected
              ? '${hours.toString().padLeft(2, '0')} hours'
              : hours.toString().padLeft(2, '0'),
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  } // end method
} // end class
