import 'dart:convert';

import 'package:bhagvat_gita/repos/audioplayer_repo.dart';
import 'package:bhagvat_gita/repos/ttsrepo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

part 'ttsmusic_event.dart';
part 'ttsmusic_state.dart';

class ttsmusicBloc extends Bloc<ttsmusicEvent, ttsmusicState> {
  ttsmusicBloc() : super(ttsmusicInitial()) {
    on<ttsmusicsourceset>((event, emit) async {
      emit(ttsmusicLoading());
      if (await Ttsrepo().checklocalaudio(event.fileid) == true) {
        print('audio found');
        AudioRepo _ttsmusicload = AudioRepo();

        var extdir = await getApplicationDocumentsDirectory();
        var getpath = Ttsrepo().getlocalaudio(event.fileid);
        await _ttsmusicload.startAudioplayer(
            event.audioplayer,
            Uri.file(
                ("${(extdir)!.path}/${event.fileid}/${event.fileid}.wav")));

        emit(ttsmusicready(
          audioplayer: event.audioplayer,
        ));
      } else {
        try {
          var base64out =
              await Ttsrepo().requesttts(event.source, 'or', event.gender);

          var file = await Ttsrepo().localFile(event.fileid, event.folderid);

          emit(ttsmusicwriting());

          await file.writeAsBytes(base64.decode(base64out));

          await AudioRepo()
              .startAudioplayer(event.audioplayer, Uri.file(file.path));

          emit(ttsmusicready(
            audioplayer: event.audioplayer,
          ));
        } catch (e) {
          print(e);
          emit(ttsmusicError());
        }
      }
    });
    on<ttsmusicplay>((event, emit) async {
      AudioRepo _ttsmusicload = AudioRepo();
      AudioPlayer player = event.audioplayer;
      await _ttsmusicload.playplayer(player);
      emit(ttsmusicready(
        audioplayer: player,
      ));
    });

    on<ttsmusicpause>((event, emit) async {
      AudioRepo _ttsmusicload = AudioRepo();
      AudioPlayer player = event.audioplayer;
      await _ttsmusicload.pauseplayer(player);
      emit(ttsmusicready(
        audioplayer: player,
      ));
    });
    on<ttsendpause>((event, emit) async {
      AudioRepo _ttsmusicload = AudioRepo();
      AudioPlayer player = event.audioplayer;
      //await _ttsmusicload.pauseplayer(player);
      await _ttsmusicload.seekplayer(player);
      emit(ttsmusicready(
        audioplayer: player,
      ));
    });
    on<ttsmusicstop>((event, emit) async {
      AudioRepo _ttsmusicload = AudioRepo();
      AudioPlayer player = event.audioplayer;
      await _ttsmusicload.stopplayer(player);
      emit(ttsmusicready(
        audioplayer: player,
      ));
    });
  }
}
