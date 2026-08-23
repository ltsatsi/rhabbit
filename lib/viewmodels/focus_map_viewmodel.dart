// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FocusMapViewModel extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  bool _isLoading = false;
  String? _errorMessage;
  Map<DateTime, int> _dataset = {};

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<DateTime, int> get dataset => _dataset;

  // record
  Future<bool> record({required DateTime date, required String userId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final normalizedDate = DateTime(date.year, date.month, date.day);
      final session = await supabase
          .from('focusMap')
          .select()
          .eq('user_id', userId)
          .eq('date', normalizedDate.toIso8601String())
          .maybeSingle();

      // record if it doesn't exist
      if (session == null) {
        final response = await supabase.from('focusMap').insert({
          'count': 1,
          'date': normalizedDate.toIso8601String(),
          'user_id': userId,
        }).select();

        return response.isNotEmpty;
      }

      // increment if it exists
      await supabase
          .from('focusMap')
          .update({'count': (session['count'] as int) + 1})
          .eq('id', session['id'])
          .select();

      return true;
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
  Future<Map<DateTime, int>> fetch() async {
    _isLoading = true;
    _errorMessage = null;

    try {
      final response = await supabase.from('focusMap').select();
      _dataset = {};

      if (response.isEmpty) {
        return {};
      }

      for (final json in response) {
        final date = DateTime.parse(json['date']);
        final count = json['count'] as int;
        final normalizedDate = DateTime(date.year, date.month, date.day);

        _dataset[normalizedDate] = count;
        notifyListeners();
      }

      return dataset;
    } on PostgrestException catch (e) {
      _errorMessage = e.message;
      notifyListeners();

      return {};
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();

      return {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  } // end method

  // clear session data
  void clearData() {
    _dataset = {};
    _errorMessage = null;
    _isLoading = false;

    notifyListeners();
  } // end method
} //end class
