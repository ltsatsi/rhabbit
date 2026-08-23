// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

import 'package:flutter/material.dart';
import 'package:productivity_app/views/auth_gate.dart';
import 'package:productivity_app/views/focus_page.dart';
import 'package:productivity_app/views/forgot_passwd_page.dart';
import 'package:productivity_app/views/home_page.dart';
import 'package:productivity_app/views/profile_page.dart';
import 'package:productivity_app/views/reset_passwd_page.dart';
import 'package:productivity_app/views/session_page.dart';
import 'package:productivity_app/views/settings_page.dart';
import 'package:productivity_app/views/sign_in_page.dart';
import 'package:productivity_app/views/sign_up_page.dart';

class RouteManager {
  // named routes
  static const String authGate = '/';
  static const String homePage = '/homePage';
  static const String focusPage = '/focusPage';
  static const String sessionPage = '/sessionPage';
  static const String settingsPage = '/settingsPage';
  static const String profilePage = '/profilePage';
  static const String signInPage = '/signInPage';
  static const String signUpPage = '/signUpPage';
  static const String forgotPasswdPage = '/forgotPasswdPage';
  static const String resetPasswdPage = '/resetPasswdPage';

  // route generator
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case authGate:
        return MaterialPageRoute(builder: (context) => AuthGate());

      case homePage:
        return MaterialPageRoute(builder: (context) => HomePage());

      // pass data to focus page
      case focusPage:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => FocusPage(
            hours: args['hours'],
            minutes: args['minutes'],
            label: args['label'],
          ),
        );

      case sessionPage:
        return MaterialPageRoute(builder: (context) => SessionPage());
      case settingsPage:
        return MaterialPageRoute(builder: (context) => SettingsPage());
      case profilePage:
        return MaterialPageRoute(builder: (context) => ProfilePage());
      case signInPage:
        return MaterialPageRoute(builder: (context) => SignInPage());
      case signUpPage:
        return MaterialPageRoute(builder: (context) => SignUpPage());

      case forgotPasswdPage:
        return MaterialPageRoute(builder: (context) => ForgotPasswdPage());
      case resetPasswdPage:
        return MaterialPageRoute(builder: (context) => ResetPasswdPage());

      default:
        throw Exception('Route not found: RouteManager');
    }
  } // end method
} // end class
