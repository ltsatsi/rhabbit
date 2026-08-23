// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfigurations {
  // supabase
  static final String supabaseUrl = dotenv.get('SUPABASE_URL');
  static final String supabaseAnon = dotenv.get('SUPABASE_ANON_KEY');

  // google
  static final String googleWebClientId = dotenv.get('GOOGLE_WEB_CLIENT_ID');
} // end class
