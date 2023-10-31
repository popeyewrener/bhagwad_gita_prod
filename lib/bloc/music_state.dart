part of 'music_bloc.dart';

abstract class MusicState extends Equatable {
  const MusicState();

  @override
  List<Object> get props => [];
}

class MusicInitial extends MusicState {}

class Musicready extends MusicState {
  final AudioPlayer audioplayer;
  var bufferedp;
  var currentposition;
  var duration;

  Musicready({
    required this.audioplayer,
  });

  @override
  List<Object> get props => [audioplayer];
}

class MusicPlaying extends MusicState {}

class MusicLoading extends MusicState {}

class MusicPaused extends MusicState {}

class MusicCompleted extends MusicState {}

class MusicError extends MusicState {}
