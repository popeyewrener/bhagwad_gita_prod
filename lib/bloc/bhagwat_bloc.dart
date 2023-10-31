import 'package:bhagvat_gita/repos/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bhagwat_event.dart';
part 'bhagwat_state.dart';

class BhagwatBloc extends Bloc<BhagwatEvent, BhagwatState> {
  final UserRepos _userRepos;
  BhagwatBloc(this._userRepos) : super(BhagwatInitial()) {
    on<LoadbhagwatEvent>(
      (event, emit) async {
        emit(BhagwatLoading());
        try {
          final phrase =
              await _userRepos.getverse(event.lang, event.chap, event.verse);

          emit(BhagwatLoaded(phrase));
        } catch (e) {
          emit(Bhagwaterror());
        }
        print('Loaded');
      },
    );
    on<InitLoadbhagwatEvent>(
      (event, emit) async {
        emit(BhagwatLoading());
        try {
          final phrase = await _userRepos.getverse('odi', '3', '3');
          print(phrase);
          emit(BhagwatLoaded(phrase));
        } catch (e) {
          print(e);
          emit(Bhagwaterror());
        }
        print('Loaded');
      },
    );
  }
}
