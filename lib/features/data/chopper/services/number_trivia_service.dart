import 'package:chopper/chopper.dart';
import 'package:number_trivia/features/data/models/number_trivia_model.dart';

part 'number_trivia_service.chopper.dart';

@ChopperApi(baseUrl: '')
abstract class NumberTriviaService extends ChopperService {
  static NumberTriviaService create([ChopperClient? client]) =>
      _$NumberTriviaService(client);

  @Get(path: '/{number}')
  Future<Response<NumberTriviaModel>> getConcreteNumberTrivia(
    @Path('number') int number,
  );

  @Get(path: '/random')
  Future<Response<NumberTriviaModel>> getRandomNumberTrivia();
}
