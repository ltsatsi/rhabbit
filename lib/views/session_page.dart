import 'package:flutter/material.dart';
import 'package:productivity_app/core/constants/app_color.dart';
import 'package:productivity_app/core/routes/route_manager.dart';
import 'package:productivity_app/core/widgets/hours_tile.dart';
import 'package:productivity_app/core/widgets/minutes_tile.dart';
import 'package:productivity_app/services/sound_service.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  final _labelController = TextEditingController();
  final _soundService = SoundService();

  FixedExtentScrollController _hrsController = FixedExtentScrollController();
  FixedExtentScrollController _minController = FixedExtentScrollController();

  int selectedHours = 0;
  int selectedMinutes = 25;

  void _cancelSession() {
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
                  height: 70,
                  width: 70,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColor.seedColor.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.timelapse,
                    size: 40,
                    color: AppColor.seedColor,
                  ),
                ),
                SizedBox(height: 10),

                // title
                Text(
                  'Leading Already?',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                Text(
                  'Great progress so far! Every focused minute counts. ',
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

                      Navigator.pushReplacementNamed(
                        context,
                        RouteManager.homePage,
                      );
                    },
                    child: Text(
                      'Yes',
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Stay',
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
  void initState() {
    super.initState();

    _hrsController = FixedExtentScrollController(initialItem: 0);
    _minController = FixedExtentScrollController(initialItem: 25);
  }

  @override
  void dispose() {
    super.dispose();
    _soundService.dispose();
    _labelController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 55.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: 'Create a\n',
                  children: [
                    TextSpan(
                      text: 'Focus Session',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppColor.seedColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                'Set your duration and give your session a label',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColor.muted,
                ),
              ),
              const SizedBox(height: 65),

              // Duration
              Text(
                'Duration',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.seedColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 50,
                            perspective: 0.005,
                            diameterRatio: 1.2,
                            controller: _hrsController,
                            physics: FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (value) {
                              setState(() {
                                selectedHours = value;
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 13,
                              builder: (context, index) {
                                return HoursTile(
                                  hours: index,
                                  isSelected: index == selectedHours,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 50,
                            perspective: 0.005,
                            diameterRatio: 1.2,
                            controller: _minController,
                            physics: FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (value) {
                              setState(() {
                                selectedMinutes = value;
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 60,
                              builder: (context, index) {
                                return MinutesTile(
                                  mins: index,
                                  isSelected: index == selectedMinutes,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              TextField(
                controller: _labelController,
                decoration: InputDecoration(
                  labelText: 'Label',
                  hintText: 'e.g Scrum Meeting',
                ),
              ),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.muted,
                      ),
                      onPressed: _cancelSession,
                      child: Text(
                        'Cancel',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColor.lightText,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final label = _labelController.text;

                        if (label.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please enter a session label',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColor.lightText),
                              ),
                              action: SnackBarAction(
                                label: 'Dismiss',
                                onPressed: () {},
                              ),
                            ),
                          );
                          return;
                        }

                        if (selectedHours <= 0 && selectedMinutes <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please scroll to select session duration',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColor.lightText),
                              ),
                              action: SnackBarAction(
                                label: 'Dismiss',
                                onPressed: () {},
                              ),
                            ),
                          );
                          return;
                        }

                        Navigator.pushNamed(
                          context,
                          RouteManager.focusPage,
                          arguments: {
                            'hours': selectedHours,
                            'minutes': selectedMinutes,
                            'label': label,
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            color: AppColor.lightText,
                          ),
                          const SizedBox(width: 5),

                          Text(
                            'Start',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.lightText,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
