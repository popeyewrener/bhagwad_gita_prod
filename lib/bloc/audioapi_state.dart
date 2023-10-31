part of 'audioapi_bloc.dart';

abstract class AudioapiState extends Equatable {
  const AudioapiState();
  
  @override
  List<Object> get props => [];
}

class AudioapiInitial extends AudioapiState {}
