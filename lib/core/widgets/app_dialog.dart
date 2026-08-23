// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:productivity_app/core/constants/app_color.dart';

class AppDialog extends StatelessWidget {
  // required fields
  final String animation;
  final String title;
  final String description;
  final Function()? onPressed;

  // optionsl fields
  final String? actionText;
  final bool? animationRepeat;
  final CrossAxisAlignment? crossAxisAlignment;

  const AppDialog({
    super.key,
    required this.animation,
    required this.title,
    required this.description,
    required this.onPressed,

    // optional parameters
    this.actionText,
    this.animationRepeat,
    this.crossAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // animation
            Lottie.asset(animation, height: 100, repeat: animationRepeat),

            Column(
              crossAxisAlignment:
                  crossAxisAlignment ?? CrossAxisAlignment.start,
              children: [
                // title
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 10),

                // description
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColor.muted),
                ),
              ],
            ),
          ],
        ),
      ),

      // dialog actions
      actions: [
        SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            child: Text(
              actionText ?? 'Ok',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColor.lightText,
              ),
            ),
          ),
        ),
      ],
    );
  } // end method
} // end class
