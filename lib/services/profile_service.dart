// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final supabase = Supabase.instance.client;

  // create profile
  Future<void> create(Map<String, dynamic> json) async {
    await supabase.from('profiles').insert(json);
  } // end method

  // does user exist
  Future<bool> isExist(String userId) async {
    final response = await supabase
        .from('profiles')
        .select('user_id')
        .eq('user_id', userId)
        .maybeSingle();

    return response != null;
  } // end method

  // set account as deleted (soft delete)
  Future<void> softDelete(String userId) async {
    await supabase
        .from('profiles')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('user_id', userId);
  } // end method
} // end class
