// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

import 'package:flutter/material.dart';
import 'package:productivity_app/core/constants/app_color.dart';

class SettingsTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String subtitle;
  final Widget trailingIcon;
  final Color? iconColor;

  final Function()? onTap;

  const SettingsTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    required this.trailingIcon,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    // check current theme
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // use icon color if tile has icon
    Color bgColor;

    if (iconColor != null) {
      bgColor = iconColor!.withOpacity(0.05);
    } else {
      bgColor = isDarkTheme
          ? const Color.fromARGB(255, 24, 24, 24)
          : const Color(0xFFEBEBEB);
    } // end if-else

    return Container(
      decoration: BoxDecoration(
        color: isDarkTheme
            ? const Color.fromARGB(255, 10, 10, 10)
            : AppColor.lightFill,
        borderRadius: BorderRadius.circular(12),

        border: isDarkTheme
            ? Border.all(color: Colors.transparent)
            : Border.all(color: AppColor.borderLight),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            leadingIcon,
            color: iconColor ?? Theme.of(context).iconTheme.color,
          ),
        ),
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge),

        subtitle: Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColor.muted),
        ),
        trailing: trailingIcon,
      ),
    );
  } // end method
} // end class
