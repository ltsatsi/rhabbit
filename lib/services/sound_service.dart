// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playSessionComplete() async {
    await _player.play(AssetSource('sounds/success.wav'));
  } // end method

  Future<void> playFailSound() async {
    await _player.play(AssetSource('sounds/fail.wav'));
  } // end method

  Future<void> dispose() async {
    await _player.dispose();
  } // end method
} // end class
