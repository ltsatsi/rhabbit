// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:productivity_app/services/profile_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends ChangeNotifier {
  // viewmodel fields
  final supabase = Supabase.instance.client;
  final _profileService = ProfileService();

  bool _isLoading = false;
  String? _errorMessage;

  // viewmodel get accessors
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Session? get session => supabase.auth.currentSession;
  String get currentUserId => supabase.auth.currentUser!.id;

  // email and password sign up
  Future<bool> signUp({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final user = response.user;
        await _profileService.create({'username': email, 'user_id': user!.id});
      }

      return response.user != null;
    } on AuthApiException catch (e) {
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

  // email and password sign in
  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return response.user != null;
    } on AuthApiException catch (e) {
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

  // google sign in
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;

      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
      );

      final user = response.user;

      if (user != null) {
        final exists = await _profileService.isExist(user.id);

        if (!exists) {
          await _profileService.create({
            'username': user.email,
            'user_id': user.id,
          });
        }
      }

      return response.user != null;
    } on AuthApiException catch (e) {
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

  // sign out
  Future<void> signOut() async {
    await supabase.auth.signOut();
    notifyListeners();
  } // end method

  // delete user account from app
  Future<void> deleteAccount() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // get current user id
      final userId = supabase.auth.currentUser!.id;

      // call profiles service
      await _profileService.softDelete(userId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  } // end method

  Future<void> resetPasswd({required String email}) async {
    _isLoading = true;
    _errorMessage = null;

    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'com.ltsatsi.rhabbit://reset-password',
      );
    } on AuthApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  } // end method

  Future<void> updatePasswd({required String password}) async {
    _isLoading = true;
    _errorMessage = null;

    try {
      await supabase.auth.updateUser(UserAttributes(password: password));
    } on AuthApiException catch (e) {
      _errorMessage = e.message;
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
