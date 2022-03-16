import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/presentation/input_fields/input_number_trivia.dart';

import '../../../core/error/failure.dart';
import '../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required GetConcreteNumberTrivia concrete,
      required GetRandomNumberTrivia random,
      required this.inputConverter})
      : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(const NumberTriviaState()) {
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);

    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumber);

    on<InputNumberChanged>(_onInputNumberChanged);
  }

  @override
  void onChange(Change<NumberTriviaState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onTransition(
      Transition<NumberTriviaEvent, NumberTriviaState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  void _onInputNumberChanged(
      InputNumberChanged event, Emitter<NumberTriviaState> emit) async {
    final inputNumberTrivia = InputNumberTrivia.dirty(event.number);

    emit(state.copyWith(
      inputNumberTrivia: inputNumberTrivia,
      status: Formz.validate([inputNumberTrivia]),
    ));
  }

  void _onGetTriviaForConcreteNumber(
      GetTriviaForConcreteNumber event, Emitter<NumberTriviaState> emit) async {
    if (state.status.isValidated) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(state.inputNumberTrivia.value);

      await inputEither.fold(
        (failure) {
          emit(
            state.copyWith(
                status: FormzStatus.submissionFailure,
                message: INVALID_INPUT_FAILURE_MESSAGE),
          );
        },
        // Although the "success case" doesn't interest us with the current test,
        // we still have to handle it somehow.
        (integer) async {
          emit(state.copyWith(status: FormzStatus.submissionInProgress));
          final failureOrTrivia =
              await getConcreteNumberTrivia(Params(number: integer));
          // final failureOrTrivia = await getRandomNumberTrivia(NoParams());
          emit(_eitherLoadedOrErrorState(failureOrTrivia));
        },
      );
    }
  }

  void _onGetTriviaForRandomNumber(
      GetTriviaForRandomNumber event, Emitter<NumberTriviaState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    // emit.isDone;
    emit(_eitherLoadedOrErrorState(failureOrTrivia));
  }

  NumberTriviaState _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> failureOrTrivia) {
    return failureOrTrivia.fold(
      (failure) => state.copyWith(
        status: FormzStatus.submissionFailure,
        message: _mapFailureToMessage(failure),
      ),
      (trivia) => state.copyWith(
        status: FormzStatus.submissionSuccess,
        inputNumberTrivia: const InputNumberTrivia.pure(),
        trivia: trivia,
      ),
    );
  }
}

String _mapFailureToMessage(Failure failure) {
  // Instead of a regular 'if (failure is ServerFailure)...'
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE;
    default:
      return 'Unexpected Error';
  }
}
