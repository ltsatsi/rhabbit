// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

import 'package:flutter/material.dart';

class MinutesTile extends StatelessWidget {
  final int mins;
  final bool isSelected;

  const MinutesTile({super.key, required this.mins, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Text(
          isSelected
              ? '${mins.toString().padLeft(2, '0')} min'
              : mins.toString().padLeft(2, '0'),
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  } // end method
} // end class
