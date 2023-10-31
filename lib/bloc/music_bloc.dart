import 'package:bhagvat_gita/repos/audioplayer_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicBloc() : super(MusicInitial()) {
    on<Musicsourceset>((event, emit) async {
      emit(MusicLoading());
      try {
        AudioRepo _musicload = AudioRepo();

        await _musicload.startAudioplayer(event.audioplayer, event.source);

        emit(Musicready(
          audioplayer: event.audioplayer,
        ));
      } catch (e) {
        print(e);
        emit(MusicError());
      }
    });
    on<Musicplay>((event, emit) async {
      AudioRepo _musicload = AudioRepo();
      AudioPlayer player = event.audioplayer;
      await _musicload.playplayer(player);
      emit(Musicready(
        audioplayer: player,
      ));
    });
    on<Musicpause>((event, emit) async {
      AudioRepo _musicload = AudioRepo();
      AudioPlayer player = event.audioplayer;
      await _musicload.pauseplayer(player);
      emit(Musicready(
        audioplayer: player,
      ));
    });
    on<Musicstop>((event, emit) async {
      AudioRepo _musicload = AudioRepo();
      AudioPlayer player = event.audioplayer;
      await _musicload.stopplayer(player);
      emit(Musicready(
        audioplayer: player,
      ));
    });
  }
}
