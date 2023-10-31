import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:bhagvat_gita/constants.dart';
import 'package:bhagvat_gita/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:bhagvat_gita/bloc/bhagwat_bloc.dart';
import 'package:bhagvat_gita/bloc/ttsmusic_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/music_bloc.dart';

class Home extends StatelessWidget {
  final lang;
  final chap;
  final verse;
  const Home({super.key, this.lang, this.chap, this.verse});

  @override
  Widget build(BuildContext context) {
    setprefs(chap, verse);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var gender = 'male';
    int i = 0;

    context.read<BhagwatBloc>()
      ..add(LoadbhagwatEvent(
          lang: lang, chap: chap.toString(), verse: verse.toString()));

    return Hero(
      tag: "${verse.toString()}",
      child: Scaffold(
        body: Stack(
          children: [
            Opacity(
              opacity: 0.3,
              child: Container(
                height: height,
                width: width,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.asset(
                    'assets/images/bhagwadimg.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: BlocBuilder<BhagwatBloc, BhagwatState>(
                  builder: (context, state) {
                    if (state is BhagwatLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is BhagwatLoaded) {
                      var ttsmusicr = false;
                      var ttscompleted = false;

                      var verseaudio = AudioPlayer();

                      AudioPlayer audioPlayer = AudioPlayer();

                      disposeplayers() {
                        verseaudio.dispose();
                        audioPlayer.dispose();
                      }

                      var purp = '';

                      {
                        for (var verse in state.result['purport']) {
                          purp = purp + '\n' + verse;
                        }
                      }

                      context.read<MusicBloc>().add(Musicsourceset(
                          audioplayer: verseaudio,
                          source: Uri.parse(state.result['audio_link'])));
                      context.read<ttsmusicBloc>().add(ttsmusicsourceset(
                          audioplayer: audioPlayer,
                          fileid: '${chap}_${verse}',
                          source: purp == "" ? 'ବ୍ୟବରଣୀ ଉପଲବ୍ଧ ନୁହେଁ ' : purp,
                          gender: gender,
                          folderid:
                              (chap.toString() + '_' + verse.toString())));
                      //print(state.result['purport'][0].toString());

                      return WillPopScope(
                        onWillPop: () async {
                          await disposeplayers();
                          return false;
                        },
                        child: Column(
                          children: [
                            Container(
                              height: height * 0.1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      state.result['chapter_name'].toString(),
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 24),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${state.result['verse_no']}',
                                          style: TextStyle(fontSize: 24),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: height * 0.2,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (state.result['verse'].runtimeType ==
                                        List)
                                      for (var verse in state.result['verse'])
                                        Text(verse.toString()),

                                    if (state.result['verse'].runtimeType ==
                                        String)
                                      Text(state.result['verse'].toString()),
                                    //Text(state.result['verse'][1].toString()),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: height * 0.12,
                              width: width,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: BlocBuilder<MusicBloc, MusicState>(
                                    builder: (context, state) {
                                      if (state is MusicLoading) {
                                        return CircularProgressIndicator();
                                      }
                                      if (state is Musicready) {
                                        state.audioplayer.positionStream
                                            .listen((event) {});
                                        state.audioplayer.playbackEventStream
                                            .listen((event) async {
                                          if (event.processingState ==
                                              ProcessingState.completed) {
                                            print("Completed");
                                            context.read<MusicBloc>()
                                              ..add(Musicpause(
                                                  audioplayer: verseaudio));
                                            if (ttsmusicr == true) {
                                              await audioPlayer
                                                  .seek(Duration.zero);
                                              context.read<ttsmusicBloc>()
                                                ..add(ttsmusicplay(
                                                    audioplayer: audioPlayer));
                                            }
                                          }
                                        });

                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  child: StreamBuilder<Object>(
                                                      stream: state.audioplayer
                                                          .playerStateStream,
                                                      builder:
                                                          (context, snapshot) {
                                                        return Icon(state
                                                                .audioplayer
                                                                .playing
                                                            ? Icons.pause
                                                            : Icons.play_arrow);
                                                      }),
                                                  onTap: () {
                                                    state.audioplayer.playing
                                                        ? {
                                                            context.read<
                                                                MusicBloc>()
                                                              ..add(Musicpause(
                                                                  audioplayer: state
                                                                      .audioplayer))
                                                          }
                                                        : context
                                                            .read<MusicBloc>()
                                                            .add(Musicplay(
                                                                audioplayer: state
                                                                    .audioplayer));
                                                  },
                                                ),
                                                GestureDetector(
                                                  child: Icon(Icons.stop),
                                                  onTap: () {
                                                    context.read<MusicBloc>()
                                                      ..add(Musicpause(
                                                          audioplayer: state
                                                              .audioplayer));
                                                    context.read<MusicBloc>()
                                                      ..add(Musicstop(
                                                          audioplayer: state
                                                              .audioplayer));
                                                  },
                                                )
                                              ],
                                            ),
                                            StreamBuilder<Object>(
                                                stream: state
                                                    .audioplayer.positionStream,
                                                builder: (context, snapshot) {
                                                  return ProgressBar(
                                                    thumbGlowColor:
                                                        Colors.orange,
                                                    thumbColor:
                                                        Colors.orange[700],
                                                    baseBarColor: Colors.white,
                                                    progressBarColor:
                                                        Colors.orange,
                                                    bufferedBarColor:
                                                        Colors.orange[300],
                                                    progress: state
                                                        .audioplayer.position,
                                                    total: state.audioplayer
                                                            .duration ??
                                                        Duration.zero,
                                                    buffered: state.audioplayer
                                                        .bufferedPosition,
                                                    onSeek: (value) {
                                                      state.audioplayer
                                                          .seek(value);
                                                    },
                                                  );
                                                }),
                                          ],
                                        );
                                      }
                                      return Text('Loading');
                                    },
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: height * 0.3,
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: [
                                    Text(purp),
                                  ],
                                )),
                              ),
                            ),
                            Container(
                                height: height * 0.12,
                                child: Container(
                                  width: width,
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: BlocBuilder<ttsmusicBloc,
                                        ttsmusicState>(
                                      builder: (context, state) {
                                        if (state is ttsmusicLoading) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        if (state is ttsmusicwriting) {
                                          return Center(
                                              child: Text('Writing to file!'));
                                        }
                                        if (state is ttsmusicready) {
                                          state.audioplayer.playbackEventStream
                                              .listen((event) async {
                                            ttsmusicr = true;
                                            if (event.processingState ==
                                                ProcessingState.completed) {
                                              //
                                              ttscompleted = true;
                                              i += 1;
                                              if (ttscompleted && i < 2) {
                                                //print('Entered ');
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    actionsAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    title: const Text(
                                                        "PLAY NEXT VERSE"),
                                                    content: const Text(
                                                        "Click on next to play next verse!"),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                          onPressed: () async {
                                                            await disposeplayers();

                                                            await Navigator.of(
                                                                    context)
                                                                .pushAndRemoveUntil(
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            Home(
                                                                              lang: 'odi',
                                                                              chap: (int.parse(chap) == 18)
                                                                                  ? '1'
                                                                                  : (int.parse(verse) < (chap_verse[int.parse(chap)]))
                                                                                      ? chap
                                                                                      : (int.parse(chap) + 1).toString(),
                                                                              verse: (int.parse(verse)) < chap_verse[int.parse(chap)] ? ((int.parse(verse)) + 1).toString() : '1',
                                                                            )),
                                                                    (Route<dynamic>
                                                                            route) =>
                                                                        false);
                                                          },
                                                          child: Text('NEXT')),
                                                      ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('CANCEL'))
                                                    ],
                                                  ),
                                                );
                                              }
                                              context.read<ttsmusicBloc>()
                                                ..add(ttsmusicpause(
                                                    audioplayer: audioPlayer));
                                            }
                                          });

                                          return Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    child: StreamBuilder<
                                                            Object>(
                                                        stream: audioPlayer
                                                            .playerStateStream,
                                                        builder: (context,
                                                            snapshot) {
                                                          return Icon(audioPlayer
                                                                  .playing
                                                              ? Icons.pause
                                                              : Icons
                                                                  .play_arrow);
                                                        }),
                                                    onTap: () {
                                                      state.audioplayer.playing
                                                          ? {
                                                              context.read<
                                                                  ttsmusicBloc>()
                                                                ..add(ttsmusicpause(
                                                                    audioplayer:
                                                                        audioPlayer))
                                                            }
                                                          : context
                                                              .read<
                                                                  ttsmusicBloc>()
                                                              .add(ttsmusicplay(
                                                                  audioplayer:
                                                                      audioPlayer));
                                                    },
                                                  ),
                                                  GestureDetector(
                                                    child: Icon(Icons.stop),
                                                    onTap: () {
                                                      context
                                                          .read<ttsmusicBloc>()
                                                        ..add(ttsmusicpause(
                                                            audioplayer:
                                                                audioPlayer));
                                                      context
                                                          .read<ttsmusicBloc>()
                                                        ..add(ttsmusicstop(
                                                            audioplayer:
                                                                audioPlayer));
                                                    },
                                                  )
                                                ],
                                              ),
                                              StreamBuilder<Object>(
                                                  stream: state.audioplayer
                                                      .positionStream,
                                                  builder: (context, snapshot) {
                                                    return ProgressBar(
                                                      thumbColor:
                                                          Colors.orange[800],
                                                      baseBarColor:
                                                          Colors.white,
                                                      progressBarColor:
                                                          Colors.orange,
                                                      bufferedBarColor:
                                                          Colors.orange[100],
                                                      progress:
                                                          audioPlayer.position,
                                                      total: audioPlayer
                                                              .duration ??
                                                          Duration.zero,
                                                      buffered: audioPlayer
                                                          .bufferedPosition,
                                                      onSeek: (value) {
                                                        audioPlayer.seek(value);
                                                      },
                                                    );
                                                  }),
                                            ],
                                          );
                                        }
                                        return Text('Loading');
                                      },
                                    ),
                                  ),
                                )),
                            GestureDetector(
                              onTap: () async {
                                await disposeplayers();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => Homepage()),
                                    (Route<dynamic> route) => false);
                              },
                              child: Container(
                                height: height * 0.05,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Icon(
                                        Icons.arrow_back,
                                      ),
                                      height: height * 0.05,
                                    ),
                                    Text('BACK')
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

setprefs(chap, verse) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs!.setString('lastchap', chap);
  prefs!.setString('lastverse', verse);
}
