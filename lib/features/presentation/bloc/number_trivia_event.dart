part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  const GetTriviaForConcreteNumber();

  @override
  List<Object?> get props => [];
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {
  @override
  List<Object?> get props => [];
}

class InputNumberChanged extends NumberTriviaEvent {
  const InputNumberChanged(this.number);

  final String number;

  @override
  List<Object> get props => [number];
}
