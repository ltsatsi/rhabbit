// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

import 'package:flutter/material.dart';
import 'package:productivity_app/models/focus_session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FocusSessionViewModel extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  bool _isLoading = false;
  String? _errorMessage = null;
  List<FocusSession> _sessions = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<FocusSession> get sessions => _sessions;

  // create
  Future<bool> create({
    required String label,
    required int durationInSeconds,
    required String userId,
  }) async {
    _isLoading = true;
    _errorMessage = null;

    try {
      final response = await supabase.from('focusSession').insert({
        'label': label,
        'duration': durationInSeconds,
        'created_at': DateTime.now().toIso8601String(),
        'user_id': userId,
      }).select();

      if (response.isNotEmpty) {
        _sessions.add(FocusSession.fromJson(response.first));
        notifyListeners();
      }

      return response.isNotEmpty;
    } on PostgrestException catch (e) {
      _errorMessage = e.message;
      notifyListeners();

      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  } // end method

  // fetch
  Future<List<FocusSession>> fetch() async {
    _isLoading = true;
    _errorMessage = null;

    try {
      final currentDay = DateTime.now().day;
      final response = await supabase.from('focusSession').select();

      if (response.isEmpty) {
        return [];
      }

      _sessions = response
          .map((json) => FocusSession.fromJson(json))
          .where((x) => x.createdAt.day == currentDay)
          .toList();
      notifyListeners();

      return _sessions;
    } on PostgrestException catch (e) {
      _errorMessage = e.message;
      notifyListeners();

      return [];
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();

      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  } // end method

  // update
  Future<bool> update({required String id, required String label}) async {
    _isLoading = true;
    _errorMessage = null;

    try {
      final response = await supabase
          .from('focusSession')
          .update({'label': label})
          .eq('id', id)
          .select();

      return response.isNotEmpty;
    } on PostgrestException catch (e) {
      _errorMessage = e.message;
      notifyListeners();

      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  } // end method

  // clear session data
  void clearData() {
    _sessions = [];
    _errorMessage = null;
    _isLoading = false;

    notifyListeners();
  } // end method
} // end class
