import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'audioapi_event.dart';
part 'audioapi_state.dart';

class AudioapiBloc extends Bloc<AudioapiEvent, AudioapiState> {
  AudioapiBloc() : super(AudioapiInitial()) {
    on<AudioapiEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
