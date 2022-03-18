import 'package:chopper/chopper.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:get_it/get_it.dart';
import 'package:number_trivia/features/data/chopper/chopper_client.dart';
import 'package:number_trivia/features/data/chopper/services/number_trivia_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/data/datasources/number_trivia_data_source.dart';
import 'features/data/datasources/number_trivia_local_data_source.dart';
import 'features/data/repositories/number_trivia_repository_impl.dart';
import 'features/domain/repositories/number_trivia_repository.dart';
import 'features/domain/usecases/get_concrete_number_trivia.dart';
import 'features/domain/usecases/get_random_number_trivia.dart';
import 'features/presentation/bloc/number_trivia_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  //Bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      concrete: sl(),
      random: sl(),
      inputConverter: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources

  sl.registerSingleton<ChopperClient>(ChopperClientBuilder.buildChopperClient(
    [NumberTriviaService.create()],
  ));

  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl(), chopperClient: sl()),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  );

//! Core
  sl.registerLazySingleton(() => InputConverter());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
