import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:productivity_app/core/constants/app_color.dart';
import 'package:productivity_app/core/routes/route_manager.dart';
import 'package:productivity_app/core/widgets/settings_tile.dart';
import 'package:productivity_app/providers/theme_provider.dart';
import 'package:productivity_app/services/notification_service.dart';
import 'package:productivity_app/viewmodels/auth_viewmodel.dart';
import 'package:productivity_app/viewmodels/profile_viewmodel.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final secionHeight = 25.0;
  bool systemDark = true;
  bool notificationsEnabled = false;

  void _aboutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 220,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // animation
                Lottie.asset(
                  'assets/animations/app_anim.json',
                  height: 100,
                  repeat: true,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // title
                    Text(
                      'RHabbit',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 10),

                    // description
                    Text(
                      'v0.1.0+1 (unreleased)',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColor.muted),
                    ),
                    SizedBox(height: 20),

                    Text(
                      'Your personal focus tracker',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
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
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Ok',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColor.lightText,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _feedbackDialog() {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 220,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    // icon / animation
                    Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isDarkTheme
                            ? const Color(0x564E4E4E)
                            : const Color(0xFFDAD9D9),
                      ),
                      child: Icon(
                        CupertinoIcons.heart,
                        size: 40,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    SizedBox(height: 10),

                    // title
                    Text(
                      'Send Feedback',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // textfield
                TextField(
                  maxLines: 4,
                  minLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      letterSpacing: 1.25,
                      color: AppColor.muted,
                    ),
                    hintText:
                        'Share your thoughts, report bugs, or request features ..',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // row
            Row(
              children: [
                // cancel button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.muted,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColor.lightText,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 7),

                // send button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Send',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColor.lightText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _supportDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 220,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // icon / animation
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.pink.withOpacity(0.15),
                  ),
                  child: Icon(
                    CupertinoIcons.heart_fill,
                    size: 40,
                    color: Colors.pink,
                  ),
                ),
                SizedBox(height: 10),

                // title
                Text(
                  'Support the independent developer',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Watch a short ad to support the independent developer.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColor.muted,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                onPressed: () {},
                child: Text(
                  'Watch ad',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColor.lightText,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Maybe later',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColor.muted,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _clearDataDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 220,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // icon / animation
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColor.danger.withOpacity(0.15),
                  ),
                  child: Icon(
                    Icons.data_saver_off_sharp,
                    size: 40,
                    color: AppColor.danger,
                  ),
                ),
                SizedBox(height: 10),

                // title
                Text(
                  'Clear Data',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                Text(
                  'This will permanently delete all your local data including session data and progress. This action cannot be undone.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColor.muted,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            // row
            Row(
              children: [
                // cancel button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.muted,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColor.lightText,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),

                // send button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.danger,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Clear',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColor.lightText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _deleteAccountDialog(String username) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 220,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // icon / animation
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColor.danger.withOpacity(0.15),
                  ),
                  child: Icon(Icons.delete, size: 40, color: AppColor.danger),
                ),
                SizedBox(height: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title
                    Text(
                      'Delete User Account',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),

                    Text(
                      'This action will permanently delete account: $username from RHabbit. Please be adviced this action cannot be undone!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColor.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            // row
            Row(
              children: [
                // cancel button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.muted,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Back',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColor.lightText,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),

                // send button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.danger,
                    ),
                    onPressed: () {
                      // call supabase delete
                      context.read<AuthViewModel>().deleteAccount();

                      // update UI delete
                      context.read<ProfileViewModel>().setAsDeleted();

                      // sign user out
                      context.read<AuthViewModel>().signOut();

                      Navigator.pushNamed(context, RouteManager.signInPage);
                    },
                    child: Text(
                      'Delete',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColor.lightText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = context.watch<ThemeProvider>().isDarkTheme;
    final hasSession = context.watch<AuthViewModel>().session != null;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 50.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Builder(
                      builder: (context) {
                        return GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            child: Image.asset(
                              height: 16,
                              'assets/images/icons/arrow_back.png',
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              SizedBox(height: 25),

              Text(
                'General',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 15),

              SettingsTile(
                leadingIcon: Icons.info_outline,
                title: 'About',
                subtitle: 'Read more about',
                trailingIcon: Icon(Icons.chevron_right),
                onTap: _aboutDialog,
              ),
              SizedBox(height: 10),

              SettingsTile(
                leadingIcon: Icons.chat_bubble,
                title: 'Send Feedback',
                subtitle: 'Report bugs or request features',
                trailingIcon: Icon(Icons.chevron_right),
                onTap: _feedbackDialog,
              ),
              SizedBox(height: secionHeight),

              Text(
                'Preferences',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 15),

              SettingsTile(
                leadingIcon: isDarkTheme
                    ? CupertinoIcons.moon
                    : Icons.light_mode,
                title: isDarkTheme ? 'Dark Mode' : 'Light Mode',
                subtitle: 'System theme mode',
                trailingIcon: Switch(
                  value: context.watch<ThemeProvider>().isDarkTheme,
                  onChanged: (value) {
                    setState(() {
                      context.read<ThemeProvider>().setTheme(value);
                    });
                  },
                ),
              ),
              SizedBox(height: 10),

              SettingsTile(
                leadingIcon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: notificationsEnabled
                    ? 'Daily reminders on'
                    : 'Daily reminders off',
                trailingIcon: Switch(
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });

                    if (notificationsEnabled) {
                      NotificationService().showNotification(
                        title: 'Notifications Enabled',
                        body:
                            'Great decision! RHabbit will help you stay focused and productive.',
                      );
                    } else {
                      NotificationService().showNotification(
                        title: 'Notifications Disabled',
                        body: 'RHabbit will no longer send notifications.',
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: secionHeight),

              Text(
                'Support',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 15),

              SettingsTile(
                leadingIcon: CupertinoIcons.heart_fill,
                iconColor: Colors.pink,
                title: 'Support the indie dev',
                subtitle: 'Watch an ad',
                trailingIcon: Icon(Icons.chevron_right),
                onTap: _supportDialog,
              ),
              SizedBox(height: secionHeight),

              Text(
                'Account & Data',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 15),

              SettingsTile(
                leadingIcon: Icons.delete,
                iconColor: AppColor.danger,
                title: 'Clear Data',
                subtitle: 'Remove all data',
                trailingIcon: Icon(Icons.chevron_right),
                onTap: _clearDataDialog,
              ),
              SizedBox(height: secionHeight),

              if (hasSession)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        final username =
                            context
                                .read<ProfileViewModel>()
                                .profile
                                ?.username ??
                            '<CURRENT USER>';

                        _deleteAccountDialog(username);
                      },
                      child: Text(
                        'Delete Account',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppColor.danger),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
