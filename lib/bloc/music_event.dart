part of 'music_bloc.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();

  @override
  List<Object> get props => [];
}

class Musicsourceset extends MusicEvent {
  Uri source;
  AudioPlayer audioplayer;
  Musicsourceset({
    required this.audioplayer,
    required this.source,
  });
  @override
  List<Object> get props => [source, audioplayer];
}

class Musicplay extends MusicEvent {
  AudioPlayer audioplayer;
  Musicplay({
    required this.audioplayer,
  });
  @override
  List<Object> get props => [audioplayer];
}

class Musicpause extends MusicEvent {
  AudioPlayer audioplayer;
  Musicpause({
    required this.audioplayer,
  });
  @override
  List<Object> get props => [audioplayer];
}

class Musicstop extends MusicEvent {
  AudioPlayer audioplayer;
  Musicstop({
    required this.audioplayer,
  });
  @override
  List<Object> get props => [audioplayer];
}
