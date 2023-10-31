part of 'bhagwat_bloc.dart';

abstract class BhagwatEvent extends Equatable {
  const BhagwatEvent();

  @override
  List<Object> get props => [];
}

class LoadbhagwatEvent extends BhagwatEvent {
  String lang;
  String chap;
  String verse;
  LoadbhagwatEvent({
    required this.lang,
    required this.chap,
    required this.verse,
  });

  @override
  List<Object> get props => [lang, chap, verse];
}

class InitLoadbhagwatEvent extends BhagwatEvent {
  @override
  List<Object> get props => [];
}
