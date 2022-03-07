import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/features/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/domain/usecases/get_concrete_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

/*class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}*/

@GenerateMocks([NumberTriviaRepository])
void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');
  mockNumberTriviaRepository = MockNumberTriviaRepository();
  usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);

  test(
    'should get trivia for the number from the repository',
    () async {
      // "On the fly" implementation of the Repository using the Mockito package.
      // When getConcreteNumberTrivia is called with any argument, always answer with
      // the Right "side" of Either containing a test NumberTrivia object.
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // The "act" phase of the test. Call the not-yet-existent method.
      final result = await usecase(const Params(number: tNumber));
      // UseCase should simply return whatever was returned from the Repository
      expect(result, const Right(tNumberTrivia));
      // Verify that the method has been called on the Repository
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      // Only the above method should be called and nothing more.
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
