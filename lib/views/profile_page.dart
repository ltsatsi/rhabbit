import 'package:flutter/material.dart';
import 'package:productivity_app/core/constants/app_color.dart';
import 'package:productivity_app/core/routes/route_manager.dart';
import 'package:productivity_app/models/profile.dart';
import 'package:productivity_app/viewmodels/auth_viewmodel.dart';
import 'package:productivity_app/viewmodels/focus_map_viewmodel.dart';
import 'package:productivity_app/viewmodels/focus_session_viewmodel.dart';
import 'package:productivity_app/viewmodels/profile_viewmodel.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    context.read<ProfileViewModel>().fetchProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final noSession = context.watch<AuthViewModel>().session == null;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 50.0),
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
                        onTap: () =>
                            Navigator.pushNamed(context, RouteManager.homePage),
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
                Text('Profile', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            SizedBox(height: 20),

            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: isDarkTheme
                          ? AppColor.darkFill
                          : AppColor.lightFill,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      noSession ? Icons.cloud_off : Icons.person_outline,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 15),

                  Selector<ProfileViewModel, Profile?>(
                    selector: (context, model) => model.profile,
                    builder: (context, model, child) {
                      return Text(
                        model?.username ?? '',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                      );
                    },
                  ),

                  SizedBox(height: 50),

                  if (noSession)
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkTheme
                            ? AppColor.darkFill
                            : AppColor.lightFill,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, RouteManager.signInPage);
                        },
                        leading: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: isDarkTheme
                                ? const Color.fromRGBO(59, 59, 59, 1)
                                : const Color.fromARGB(255, 204, 204, 204),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.person_outline),
                        ),
                        title: Text(
                          'Sign In',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        subtitle: Text(
                          'Sync across devices',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontSize: 10, color: Colors.grey[700]),
                        ),
                      ),
                    ),

                  if (!noSession)
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkTheme
                            ? AppColor.darkFill
                            : AppColor.lightFill,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        onTap: () {
                          context.read<AuthViewModel>().signOut();

                          context.read<FocusMapViewModel>().clearData();
                          context.read<FocusSessionViewModel>().clearData();

                          // sign out navigation
                          Navigator.pushReplacementNamed(
                            context,
                            RouteManager.signInPage,
                          );
                        },
                        leading: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: AppColor.danger.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.logout, color: AppColor.danger),
                        ),
                        title: Text(
                          'Sign Out',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        subtitle: Text(
                          'Sign out current device',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontSize: 10, color: Colors.grey[700]),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
