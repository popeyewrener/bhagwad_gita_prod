part of 'ttsmusic_bloc.dart';

abstract class ttsmusicState extends Equatable {
  const ttsmusicState();

  @override
  List<Object> get props => [];
}

class ttsmusicInitial extends ttsmusicState {}

class ttsmusicready extends ttsmusicState {
  final AudioPlayer audioplayer;
  var bufferedp;
  var currentposition;
  var duration;
  //final audiofile;

  ttsmusicready({
    required this.audioplayer,
  });

  @override
  List<Object> get props => [audioplayer];
}

class ttsmusicPlaying extends ttsmusicState {}

class ttsmusicLoading extends ttsmusicState {}

class ttsmusicPaused extends ttsmusicState {}

class ttsmusicCompleted extends ttsmusicState {}

class ttsmusicError extends ttsmusicState {}

class ttsmusicwriting extends ttsmusicState {}
