import 'package:flutter/material.dart';
import 'package:heatmap_calendar_plus/heatmap_calendar_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:productivity_app/core/constants/app_color.dart';
import 'package:productivity_app/core/routes/route_manager.dart';
import 'package:productivity_app/models/focus_session.dart';
import 'package:productivity_app/services/heat_map_service.dart';
import 'package:productivity_app/services/time_service.dart';
import 'package:productivity_app/viewmodels/auth_viewmodel.dart';
import 'package:productivity_app/viewmodels/focus_map_viewmodel.dart';
import 'package:productivity_app/viewmodels/focus_session_viewmodel.dart';
import 'package:productivity_app/viewmodels/profile_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _labelController = TextEditingController();

  final _timeService = TimeService();
  final _heatMapService = HeatMapService();
  final currentDate = DateTime.now();

  bool isReordering = false;

  Future<void> _editSession({
    required String id,
    required String label,
    required Duration duration,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          // dialog content
          content: SizedBox(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    // title
                    Text(
                      'Session Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 10),

                    // description
                    Text(
                      'Update your session label to match your focus goals.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColor.muted),
                    ),
                  ],
                ),

                const Spacer(),

                // textfield
                TextField(
                  controller: _labelController,
                  decoration: InputDecoration(
                    labelText: 'label',
                    labelStyle: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(
                          letterSpacing: 1.25,
                          color: AppColor.seedColor,
                        ),
                    hintText: 'Label',
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      letterSpacing: 1.25,
                      color: AppColor.muted,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // duration
                Text.rich(
                  TextSpan(
                    text: 'Duration: ',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColor.muted),
                    children: [
                      TextSpan(
                        text:
                            '${duration.inHours} hrs ${duration.inMinutes.remainder(60)} mins',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColor.seedColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // dialog buttons
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),

                // update session button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final newLabel = _labelController.text.trim();

                      // prompt user to add text
                      if (newLabel.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Session not updated: Label is required.',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColor.lightText),
                            ),
                          ),
                        );
                        return;
                      }

                      // update session
                      context.read<FocusSessionViewModel>().update(
                        id: id,
                        label: newLabel,
                      );

                      // update UI
                      context.read<FocusSessionViewModel>().fetch();

                      // pop dialog
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Save',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
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
  void initState() {
    context.read<ProfileViewModel>().fetchProfile();
    context.read<FocusMapViewModel>().fetch();
    context.read<FocusSessionViewModel>().fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final noSession = context.watch<AuthViewModel>().session == null;
    return Scaffold(
      drawer: Container(
        color: isDarkTheme ? AppColor.darkBg : AppColor.lightBg,
        child: Drawer(
          backgroundColor: Colors.transparent,

          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DrawerHeader(
                  child: Center(
                    child: Lottie.asset('assets/animations/app_anim.json'),
                  ),
                ),
                SizedBox(height: 10),

                // Tiles
                Container(
                  decoration: BoxDecoration(
                    color: isDarkTheme ? AppColor.darkFill : AppColor.lightFill,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.pushNamed(context, RouteManager.sessionPage);
                    },
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: isDarkTheme
                            ? const Color.fromARGB(255, 33, 33, 33)
                            : const Color(0xFFEBEBEB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.face_retouching_natural_sharp),
                    ),
                    title: Text(
                      'Focus',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      'Stay, focus over procastination.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: AppColor.muted,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: isDarkTheme ? AppColor.darkFill : AppColor.lightFill,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.pushNamed(context, RouteManager.settingsPage);
                    },
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: isDarkTheme
                            ? const Color.fromARGB(255, 33, 33, 33)
                            : const Color(0xFFEBEBEB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.person),
                    ),
                    title: Text(
                      'Settings',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
                SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: isDarkTheme ? AppColor.darkFill : AppColor.lightFill,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.pushNamed(context, RouteManager.profilePage);
                    },
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: isDarkTheme
                            ? const Color.fromARGB(255, 33, 33, 33)
                            : const Color(0xFFEBEBEB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.settings),
                    ),
                    title: Text(
                      'Profile',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
                SizedBox(height: 10),

                const Spacer(),

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
                        Navigator.pop(context);

                        Navigator.pushNamed(context, RouteManager.signInPage);
                      },
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: isDarkTheme
                              ? const Color.fromARGB(255, 33, 33, 33)
                              : const Color(0xFFEBEBEB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.login),
                      ),
                      title: Text(
                        'Sign In',
                        style: Theme.of(context).textTheme.bodyLarge,
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
                        Navigator.pop(context);
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
                    ),
                  ),

                SizedBox(height: 35),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
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
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                            context.read<ProfileViewModel>().fetchProfile();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            child: Image.asset(
                              height: 25,
                              'assets/images/icons/menu.png',
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Text(
                    '${_timeService.getMonth(month: currentDate.month)} ${currentDate.year}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              SizedBox(height: 20),

              // scrollable section
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Heat map calendar
                      Selector<FocusMapViewModel, Map<DateTime, int>>(
                        selector: (context, model) => model.dataset,
                        builder: (context, model, child) {
                          return HeatMapCalendar(
                            headerBuilder: (context, currentDate) =>
                                const SizedBox(),
                            type: HeatmapCalendarType.month,
                            flexible: true,
                            showColorTip: false,
                            blockSpacing: 10,
                            borderRadius: 16,

                            dayTextStyle: TextStyle(
                              color: isDarkTheme
                                  ? AppColor.lightText
                                  : AppColor.darkText,
                              fontSize: 16,
                            ),

                            weekTextStyle: TextStyle(color: AppColor.seedColor),

                            monthTextStyle: TextStyle(
                              color: isDarkTheme
                                  ? AppColor.lightText
                                  : AppColor.darkText,
                              fontSize: 16,
                            ),

                            defaultColor: isDarkTheme
                                ? AppColor.darkFill
                                : AppColor.lightFill,
                            colorMode: ColorMode.opacity,
                            datasets: _heatMapService.cleanDataset(model),
                            colorsets: const {1: AppColor.seedColor},
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // list sessions head
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isReordering
                                ? 'Reorder Sessions'
                                : 'Sessions for ${currentDate.day} ${_timeService.getMonth(month: currentDate.month)} ${currentDate.year}',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),

                          if (!isReordering)
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: isDarkTheme
                                    ? AppColor.darkFill
                                    : AppColor.lightFill,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteManager.sessionPage,
                                  );
                                },
                                icon: Icon(Icons.add, size: 15),
                              ),
                            ),

                          if (isReordering)
                            Container(
                              height: 40,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AppColor.seedColor.withOpacity(0.09),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    isReordering = false;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.done, size: 15),
                                    SizedBox(width: 5),
                                    Text('Done'),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(),

                      Selector<FocusSessionViewModel, List<FocusSession>>(
                        selector: (context, model) => model.sessions,
                        builder: (context, model, child) {
                          if (model.isEmpty) {
                            return Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
                                  // create button
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: isDarkTheme
                                          ? AppColor.darkFill
                                          : AppColor.lightFill,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          RouteManager.sessionPage,
                                        );
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                  ),
                                  SizedBox(height: 15),

                                  // no sessions yet
                                  Text(
                                    'No sessions yet',
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 5),

                                  // tap to create your first session
                                  Text(
                                    'Tap to create your first session.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppColor.muted),
                                  ),
                                ],
                              ),
                            );
                          }

                          // list sessions
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 600),
                            child: isReordering
                                ? ReorderableListView.builder(
                                    padding: EdgeInsets.only(top: 10),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: model.length,
                                    onReorderItem: (oldIndex, newIndex) {
                                      // handle reorder logic

                                      setState(() {
                                        // get tile we are moving
                                        final tile = model.removeAt(oldIndex);

                                        // place we are moving to
                                        model.insert(newIndex, tile);
                                      });
                                    },
                                    itemBuilder: (context, index) {
                                      final focusSession = model[index];
                                      return Card(
                                        key: ValueKey(focusSession.id),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              // row
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: isDarkTheme
                                                        ? AppColor.darkFill
                                                        : AppColor.lightFill,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          // leading icon
                                                          Container(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  10,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color: isDarkTheme
                                                                  ? const Color(
                                                                      0x564E4E4E,
                                                                    )
                                                                  : const Color(
                                                                      0xFFDAD9D9,
                                                                    ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12,
                                                                  ),
                                                            ),
                                                            child: Icon(
                                                              Icons.task,
                                                              color: Theme.of(
                                                                context,
                                                              ).iconTheme.color,
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),

                                                          // column
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              // session label
                                                              Text(
                                                                focusSession
                                                                    .label,
                                                                style: Theme.of(
                                                                  context,
                                                                ).textTheme.titleSmall,
                                                              ),

                                                              // session duration
                                                              Text(
                                                                '${focusSession.duration.inHours} hrs ${focusSession.duration.inMinutes.remainder(60)} mins',
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .bodyMedium
                                                                    ?.copyWith(
                                                                      color: AppColor
                                                                          .muted,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),

                                                      // Icon
                                                      Icon(
                                                        Icons.drag_handle,
                                                        size: 25,
                                                        color: AppColor.muted,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : ListView.builder(
                                    padding: EdgeInsets.only(top: 10),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: model.length,
                                    itemBuilder: (context, index) {
                                      final focusSession = model[index];
                                      return Card(
                                        key: ValueKey(focusSession.id),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              // row
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: isDarkTheme
                                                        ? AppColor.darkFill
                                                        : AppColor.lightFill,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      // leading icon
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              10,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: AppColor
                                                              .seedColor
                                                              .withOpacity(0.4),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                        child: Icon(
                                                          Icons.task,
                                                          color: AppColor
                                                              .seedColor,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),

                                                      // column
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // session label
                                                          Text(
                                                            focusSession.label,
                                                            style:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .titleSmall,
                                                          ),

                                                          // session duration
                                                          Text(
                                                            '${focusSession.duration.inHours} hrs ${focusSession.duration.inMinutes.remainder(60)} mins',
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(
                                                                  color: AppColor
                                                                      .muted,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              // trailing icon
                                              PopupMenuButton(
                                                icon: Icon(Icons.more_vert),
                                                onSelected: (value) {
                                                  // handle user selection

                                                  switch (value) {
                                                    case 'Edit':
                                                      // get text controller
                                                      _labelController.text =
                                                          focusSession.label;
                                                      // Edit session
                                                      _editSession(
                                                        id: focusSession.id,
                                                        label: _labelController
                                                            .text,
                                                        duration: focusSession
                                                            .duration,
                                                      );
                                                      break;
                                                    case 'Reorder':
                                                      setState(() {
                                                        isReordering = true;
                                                      });
                                                      // Reorder session
                                                      break;
                                                    case 'Delete':
                                                      // Delete session
                                                      break;
                                                  }
                                                },
                                                itemBuilder: (context) {
                                                  return [
                                                    PopupMenuItem(
                                                      value: 'Edit',
                                                      child: Text(
                                                        'Edit',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 'Reorder',
                                                      child: Text(
                                                        'Reorder',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 'Delete',
                                                      child: Text(
                                                        'Delete',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: AppColor
                                                                  .danger,
                                                            ),
                                                      ),
                                                    ),
                                                  ];
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
