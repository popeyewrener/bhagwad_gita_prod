part of 'ttsmusic_bloc.dart';

abstract class ttsmusicEvent extends Equatable {
  const ttsmusicEvent();

  @override
  List<Object> get props => [];
}

class ttsmusicsourceset extends ttsmusicEvent {
  String source;
  String gender;
  AudioPlayer audioplayer;
  String folderid;
  String fileid;
  ttsmusicsourceset(
      {required this.source,
      required this.audioplayer,
      required this.gender,
      required this.folderid,
      required this.fileid});
  @override
  List<Object> get props => [source, audioplayer];
}

class ttsmusicplay extends ttsmusicEvent {
  AudioPlayer audioplayer;
  ttsmusicplay({
    required this.audioplayer,
  });
  @override
  List<Object> get props => [audioplayer];
}

class ttsmusicpause extends ttsmusicEvent {
  AudioPlayer audioplayer;
  ttsmusicpause({
    required this.audioplayer,
  });
  @override
  List<Object> get props => [audioplayer];
}

class ttsendpause extends ttsmusicEvent {
  AudioPlayer audioplayer;
  ttsendpause({
    required this.audioplayer,
  });
  @override
  List<Object> get props => [audioplayer];
}

class ttsmusicstop extends ttsmusicEvent {
  AudioPlayer audioplayer;
  ttsmusicstop({
    required this.audioplayer,
  });
  @override
  List<Object> get props => [audioplayer];
}

class ttsmusicfile extends ttsmusicEvent {
  late AudioPlayer audioplayer;
  String source;
  ttsmusicfile({
    required this.source,
  });
  @override
  List<Object> get props => [audioplayer, source];
}
