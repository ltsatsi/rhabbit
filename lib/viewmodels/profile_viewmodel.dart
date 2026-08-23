// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

import 'package:flutter/material.dart';
import 'package:productivity_app/models/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileViewModel extends ChangeNotifier {
  // viewmodel fields
  final supabase = Supabase.instance.client;
  Profile? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  // viewmodel get accessors
  Profile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // fetch current user profile
  Future<Profile?> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;

    try {
      final id = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('profiles')
          .select()
          .eq('user_id', id)
          .single();

      _profile = Profile.fromJson(response);
      notifyListeners();

      return _profile;
    } on PostgrestException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return null;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  } // end method

  Future<bool> isAccountDeleted(String email) async {
    print('isAccountDeleted CALLED');
    print('Email received: "$email"');

    _isLoading = true;
    _errorMessage = null;

    try {
      print('Before query');
      final response = await supabase
          .from('profiles')
          .select('deleted_at')
          .eq('username', email)
          .maybeSingle();
      print('After query');

      if (response == null) {
        return false;
      }

      print(
        '======================================== HERE IAM ==================================================\n',
      );
      print('Email: $email');
      print(response);
      print(response['deleted_at']);
      print(
        '\n======================================== HERE IAM ==================================================',
      );

      return response['deleted_at'] != null;
    } catch (e) {
      print('DELETE CHECK ERROR: $e');
      _errorMessage = e.toString();
      notifyListeners();

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  } // end method

  // update profile UI state
  Future<void> setAsDeleted() async {
    _isLoading = true;
    _errorMessage = null;

    try {
      _profile = _profile!.copyWith(deletedAt: DateTime.now());
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  } // end method
} // end class
