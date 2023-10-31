import 'package:just_audio/just_audio.dart';

class AudioRepo {
  Future<AudioPlayer> initplayer() async {
    final AudioPlayer audioplayer = AudioPlayer();
    return audioplayer;
  }

  Future<AudioPlayer> startAudioplayer(AudioPlayer audioplayer, source) async {
    AudioSource a = AudioSource.uri(source);
    Duration? d = await audioplayer.setAudioSource(a);

    print(d);
    return audioplayer;
  }

  Future stopplayer(AudioPlayer player) async {
    await player.seek(Duration.zero);
  }

  Future pauseplayer(AudioPlayer player) async {
    await player.pause();
  }

  Future seekplayer(AudioPlayer player) async {
    await player.seek(Duration.zero);
  }

  Future playplayer(AudioPlayer player) async {
    player.play();
  }
}
