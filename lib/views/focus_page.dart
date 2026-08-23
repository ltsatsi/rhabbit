import 'package:flutter/material.dart';
import 'package:productivity_app/core/constants/app_color.dart';
import 'package:productivity_app/core/routes/route_manager.dart';
import 'package:productivity_app/core/widgets/app_dialog.dart';
import 'package:productivity_app/services/sound_service.dart';
import 'package:productivity_app/services/time_service.dart';
import 'package:productivity_app/viewmodels/auth_viewmodel.dart';
import 'package:productivity_app/viewmodels/count_down_viewmodel.dart';
import 'package:productivity_app/viewmodels/focus_map_viewmodel.dart';
import 'package:productivity_app/viewmodels/focus_session_viewmodel.dart';
import 'package:provider/provider.dart';

class FocusPage extends StatefulWidget {
  final int hours;
  final int minutes;
  final String label;

  const FocusPage({
    super.key,
    required this.hours,
    required this.minutes,
    required this.label,
  });

  @override
  State<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> {
  bool _completionHandled = false;
  final _timeService = TimeService();
  final _soundService = SoundService();

  Future<void> _createFocusSession() async {
    // supabase
    final duration = Duration(hours: widget.hours, minutes: widget.minutes);
    final userId = context.read<AuthViewModel>().currentUserId;
    final date = DateTime.now();
    final normailizedDate = DateTime(date.year, date.month, date.day);
    final errorMessage = context.read<FocusMapViewModel>().errorMessage;

    final sessionResult = await context.read<FocusSessionViewModel>().create(
      label: widget.label,
      durationInSeconds: duration.inSeconds,
      userId: userId,
    );

    if (!mounted) {
      return;
    }

    if (!sessionResult) {
      print(errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'supabase: focus session not created',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColor.lightText),
          ),
        ),
      );
      return;
    }

    final focusMapResult = await context.read<FocusMapViewModel>().record(
      date: normailizedDate,
      userId: userId,
    );

    if (!mounted) {
      return;
    }

    if (!focusMapResult) {
      print(errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'supabase: focus session not recorded $errorMessage',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColor.lightText),
          ),
        ),
      );
      return;
    }
  }

  void _showCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AppDialog(
          animation: 'assets/animations/success.json',
          animationRepeat: false,
          title: 'Session Complete',
          description: 'Great work! Your focus session has finished.',
          onPressed: () {
            // pop dialog box
            Navigator.pop(context);

            // Redirect to home page
            Navigator.pushNamed(context, RouteManager.homePage);
          },
          actionText: 'Ok',
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _completionHandled = false;

    context.read<CountDownViewModel>().startCountDown(
      hours: widget.hours,
      minutes: widget.minutes,
    );
  }

  @override
  void dispose() {
    _soundService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // session count down
            Consumer<CountDownViewModel>(
              builder: (context, model, child) {
                final formattedTime = _timeService.getFormattedTime(
                  remainingHours: model.remaining.inHours,
                  remainingMinutes: model.remaining.inMinutes,
                  remainingSeconds: model.remaining.inSeconds,
                );

                if (model.isComplete && !_completionHandled) {
                  _completionHandled = true;
                  _soundService.playSessionComplete();

                  WidgetsBinding.instance.addPostFrameCallback((context) {
                    _createFocusSession();
                    _showCompleteDialog();
                    model.clearCompletion();
                  });
                }

                return Text(
                  formattedTime,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),

            // session label
            Text(
              widget.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColor.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
