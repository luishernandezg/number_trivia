import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/features/presentation/input_fields/input_number_trivia.dart';
import 'package:bloc_test/bloc_test.dart';

import 'number_trivia_bloc_test.mocks.dart';

/*class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}*/

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
  mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
  mockInputConverter = MockInputConverter();

  bloc = NumberTriviaBloc(
    concrete: mockGetConcreteNumberTrivia,
    random: mockGetRandomNumberTrivia,
    inputConverter: mockInputConverter,
  );

  test('initialState should be Empty', () {
    // assert
    expect(bloc.state, equals(const NumberTriviaState()));
  });

  group('GetTriviaForConcreteNumber', () {
    // The event takes in a String
    const tNumberString = '1';
    // This is the successful output of the InputConverter
    final tNumberParsed = int.parse(tNumberString);
    // NumberTrivia instance is needed too, of course
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test(
      'should call the status.inputNumber.value to get input string for the conversion',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        bloc.add(const GetTriviaForConcreteNumber());
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter
            .stringToUnsignedInteger(bloc.state.inputNumber.value));
      },
    );

    /*blocTest('emits [MyState] when MyEvent is added',
        build: () {
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Right(tNumberTrivia));
          return NumberTriviaBloc(
            concrete: mockGetConcreteNumberTrivia,
            random: mockGetRandomNumberTrivia,
            inputConverter: mockInputConverter,
          );
        },
        act: (NumberTriviaBloc tbloc) =>
            tbloc.add(const GetTriviaForConcreteNumber()),
        // expect: () => [isA<MyState>()],
        verify: (_) {
          verify(() => mockInputConverter
              .stringToUnsignedInteger(bloc.state.inputNumber.value));
        });*/

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        bloc.add(const GetTriviaForConcreteNumber());
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter
            .stringToUnsignedInteger(bloc.state.inputNumber.value));
      },
    );

    test(
      'should emit [status.submissionFailure] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // assert later
        final expected = [
          const NumberTriviaState(
            status: FormzStatus.submissionFailure,
            message: INVALID_INPUT_FAILURE_MESSAGE,
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const GetTriviaForConcreteNumber());
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        bloc.add(const GetTriviaForConcreteNumber());
        await untilCalled(mockGetConcreteNumberTrivia(any));
        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [status = submissionInProgress , status = submissionSuccess] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // assert later
        final expected = [
          const NumberTriviaState(
            status: FormzStatus.submissionInProgress,
            inputNumber: InputNumberTrivia.pure(),
          ),
          const NumberTriviaState(
            status: FormzStatus.submissionSuccess,
            trivia: tNumberTrivia,
          )
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const GetTriviaForConcreteNumber());
      },
    );

    test(
      'should emit [status = submissionInProgress , status = submissionFailure] when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          const NumberTriviaState(
            status: FormzStatus.submissionInProgress,
            inputNumber: InputNumberTrivia.pure(),
          ),
          const NumberTriviaState(
            status: FormzStatus.submissionFailure,
            message: SERVER_FAILURE_MESSAGE,
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const GetTriviaForConcreteNumber());
      },
    );

    test(
      'should emit [status = submissionInProgress , status = submissionFailure] with a proper message for the error when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          const NumberTriviaState(
            status: FormzStatus.submissionInProgress,
            inputNumber: InputNumberTrivia.pure(),
          ),
          const NumberTriviaState(
            status: FormzStatus.submissionFailure,
            message: CACHE_FAILURE_MESSAGE,
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const GetTriviaForConcreteNumber());
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [status = submissionInProgress , status = submissionSuccess] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // assert later
        final expected = [
          const NumberTriviaState(
            status: FormzStatus.submissionInProgress,
            inputNumber: InputNumberTrivia.pure(),
          ),
          const NumberTriviaState(
            status: FormzStatus.submissionSuccess,
            trivia: tNumberTrivia,
          )
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [status = submissionInProgress , status = submissionFailure] when getting data fails',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          const NumberTriviaState(
            status: FormzStatus.submissionInProgress,
            inputNumber: InputNumberTrivia.pure(),
          ),
          const NumberTriviaState(
            status: FormzStatus.submissionFailure,
            message: SERVER_FAILURE_MESSAGE,
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [status = submissionInProgress , status = submissionFailure] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          const NumberTriviaState(
            status: FormzStatus.submissionInProgress,
            inputNumber: InputNumberTrivia.pure(),
          ),
          const NumberTriviaState(
            status: FormzStatus.submissionFailure,
            message: CACHE_FAILURE_MESSAGE,
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
