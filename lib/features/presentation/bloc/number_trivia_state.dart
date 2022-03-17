part of 'number_trivia_bloc.dart';

class NumberTriviaState extends Equatable {
  final FormzStatus status;
  final InputNumberTrivia inputNumber;
  final String message;
  final NumberTrivia? trivia;

  const NumberTriviaState({
    this.status = FormzStatus.pure,
    this.inputNumber = const InputNumberTrivia.pure(),
    this.message = '',
    this.trivia,
  });

  NumberTriviaState copyWith({
    FormzStatus? status,
    InputNumberTrivia? inputNumberTrivia,
    String? message,
    NumberTrivia? trivia,
  }) {
    return NumberTriviaState(
      status: status ?? this.status,
      inputNumber: inputNumberTrivia ?? this.inputNumber,
      message: message ?? this.message,
      trivia: trivia ?? this.trivia,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status, inputNumber, message, trivia];
}
