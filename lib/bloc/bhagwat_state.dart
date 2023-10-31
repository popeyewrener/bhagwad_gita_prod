part of 'bhagwat_bloc.dart';

abstract class BhagwatState extends Equatable {
  const BhagwatState();

  @override
  List<Object> get props => [];
}

class BhagwatInitial extends BhagwatState {}

class BhagwatLoading extends BhagwatState {
  @override
  List<Object> get props => [];
}

class BhagwatLoaded extends BhagwatState {
  final Map result;
  BhagwatLoaded(this.result);
  @override
  List<Object> get props => [result];
}

class Bhagwaterror extends BhagwatState {}
