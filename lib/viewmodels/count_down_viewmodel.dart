// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

import 'dart:async';
import 'package:flutter/material.dart';

class CountDownViewModel extends ChangeNotifier {
  // viewmodel fields
  Timer? _timer;
  bool _isRunning = false;
  bool _isComplete = false;
  Duration _remaining = Duration.zero;

  // viewmodel get accessors
  bool get isRunning => _isRunning;
  bool get isComplete => _isComplete;
  Duration get remaining => _remaining;

  // count down - state
  void startCountDown({required int hours, required int minutes}) {
    _isRunning = true;
    _isComplete = false;
    _remaining = Duration(hours: hours, minutes: minutes);

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds <= 0) {
        _timer?.cancel();
        _isRunning = false;
        _isComplete = true;
        notifyListeners();

        return;
      }

      _remaining -= const Duration(seconds: 1);
      notifyListeners();
    });
  } // end method

  // set count down as complete
  void clearCompletion() {
    _isComplete = false;
    notifyListeners();
  } // end method

  // clean-up timer and more
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  } // end method
} // end class
