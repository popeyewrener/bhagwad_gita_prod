import 'package:bhagvat_gita/bloc/bhagwat_bloc.dart';
import 'package:bhagvat_gita/bloc/ttsmusic_bloc.dart';
import 'package:bhagvat_gita/repos/repository.dart';
//import 'package:bhagvat_gita/repos/ttsrepo.dart';

import 'package:bhagvat_gita/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/music_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return RepositoryProvider(
      create: (context) => UserRepos(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (((context) =>
                  BhagwatBloc(RepositoryProvider.of<UserRepos>(context))))),
          BlocProvider(create: ((context) => MusicBloc())),
          BlocProvider(create: ((context) => ttsmusicBloc())),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark(),
            title: 'Bhagwad gita ODIA',
            home:
                Homepage() /* RepositoryProvider(
            create: ((context) => UserRepos()),
            child: Home(),
          ),*/
            ),
      ),
    );
  }
}
