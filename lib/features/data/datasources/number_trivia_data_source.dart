import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:number_trivia/features/data/chopper/services/number_trivia_service.dart';

import '../../../core/error/exception.dart';
import '../models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;
  final ChopperClient chopperClient;

  NumberTriviaRemoteDataSourceImpl(
      {required this.client, required this.chopperClient});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    /*const String authority = 'numbersapi.com';
    final String path = number.toString();
    var url = Uri.http(authority, path);

    return _getTriviaFromUrl(url);*/
    final response = await chopperClient
        .getService<NumberTriviaService>()
        .getConcreteNumberTrivia(number);
    if (response.statusCode == 200) {
      return response.body!;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    /*const String authority = 'numbersapi.com';
    const String path = 'random';
    var url = Uri.http(authority, path);

    return _getTriviaFromUrl(url);*/

    final response = await chopperClient
        .getService<NumberTriviaService>()
        .getRandomNumberTrivia();

    if (response.statusCode == 200) {
      return response.body!;
    } else {
      throw ServerException();
    }
    /*try {
      final response = await chopperClient
          .getService<NumberTriviaService>()
          .getRandomNumberTrivia();

      if (response.statusCode == 200) {
        return response.body!;
      } else {
        throw ServerException();
      }
    } catch (e) {
      // print(e as Exception);
      throw ServerException();
    }*/
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(Uri url) async {
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJsonFactory(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
