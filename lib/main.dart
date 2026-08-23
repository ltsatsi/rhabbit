// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:productivity_app/core/config/app_configurations.dart';
import 'package:productivity_app/core/routes/route_manager.dart';
import 'package:productivity_app/core/themes/app_theme.dart';
import 'package:productivity_app/providers/theme_provider.dart';
import 'package:productivity_app/services/notification_service.dart';
import 'package:productivity_app/viewmodels/auth_viewmodel.dart';
import 'package:productivity_app/viewmodels/count_down_viewmodel.dart';
import 'package:productivity_app/viewmodels/focus_map_viewmodel.dart';
import 'package:productivity_app/viewmodels/focus_session_viewmodel.dart';
import 'package:productivity_app/viewmodels/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // local date config
  await initializeDateFormatting();

  // load dotenv
  await dotenv.load(fileName: '.env');

  // supabse config
  await Supabase.initialize(
    url: AppConfigurations.supabaseUrl,
    anonKey: AppConfigurations.supabaseAnon,
  );

  // notifcations config
  final notificationService = NotificationService();
  await notificationService.initNotification();

  // google config
  await GoogleSignIn.instance.initialize(
    serverClientId: AppConfigurations.googleWebClientId,
  );

  runApp(const MainApp());
} // end class

// Global variables
final navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();

    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      data,
    ) {
      final event = data.event;

      if (event == AuthChangeEvent.passwordRecovery) {
        navigatorKey.currentState?.pushNamed(RouteManager.resetPasswdPage);
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // state management - viewmodels
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
        ChangeNotifierProvider(create: (context) => FocusMapViewModel()),
        ChangeNotifierProvider(create: (context) => CountDownViewModel()),
        ChangeNotifierProvider(create: (context) => FocusSessionViewModel()),
      ],

      builder: (context, child) {
        return MaterialApp(
          // Application config
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: const [Locale('en')],

          // Application theme
          themeMode: context.watch<ThemeProvider>().themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,

          // Application routing
          initialRoute: RouteManager.authGate,
          onGenerateRoute: RouteManager.onGenerateRoute,
        );
      },
    );
  } // end method
} // end class
