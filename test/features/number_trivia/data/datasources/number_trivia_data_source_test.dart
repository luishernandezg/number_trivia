import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/chopper/chopper_client.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia/features/data/chopper/services/number_trivia_service.dart';
import 'package:number_trivia/features/data/datasources/number_trivia_data_source.dart';
import 'package:number_trivia/features/data/models/number_trivia_model.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'package:http/testing.dart';

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockClient mockHttpClient;
  ChopperClient chopperClient;

  setUp(() {
    mockHttpClient = MockClient((request) async {
      if (request.url.path == "/1") {
        return http.Response(fixture('trivia.json'), 200);
      }
      return http.Response('', 404);
    });
    chopperClient = ChopperClientBuilder.buildChopperClient(
        [NumberTriviaService.create()], mockHttpClient);
    dataSource = NumberTriviaRemoteDataSourceImpl(chopperClient: chopperClient);
  });

  mockHttpClient = MockClient((request) async {
    if (request.url.path == "/1") {
      return http.Response(fixture('trivia.json'), 200);
    }
    return http.Response('', 404);
  });
  chopperClient = ChopperClientBuilder.buildChopperClient(
      [NumberTriviaService.create()], mockHttpClient);
  dataSource = NumberTriviaRemoteDataSourceImpl(chopperClient: chopperClient);

  void setUpMockHttpClientSuccess200() {
    mockHttpClient = MockClient((request) async {
      return http.Response(fixture('trivia.json'), 200);
    });
    chopperClient = ChopperClientBuilder.buildChopperClient(
        [NumberTriviaService.create()], mockHttpClient);
    dataSource = NumberTriviaRemoteDataSourceImpl(chopperClient: chopperClient);
  }

  void setUpMockHttpClientSuccess200When(
      {required Map<String, String> headers, required Uri url}) {
    mockHttpClient = MockClient((request) async {
      if (mapEquals(request.headers, headers) && request.url == url) {
        return http.Response(fixture('trivia.json'), 200);
      } else {
        return http.Response('Something went wrong', 404);
      }
    });
    chopperClient = ChopperClientBuilder.buildChopperClient(
        [NumberTriviaService.create()], mockHttpClient);
    dataSource = NumberTriviaRemoteDataSourceImpl(chopperClient: chopperClient);
  }

  void setUpMockHttpClientFailure404() {
    mockHttpClient = MockClient((request) async {
      return http.Response('Something went wrong', 404);
    });
    chopperClient = ChopperClientBuilder.buildChopperClient(
        [NumberTriviaService.create()], mockHttpClient);
    dataSource = NumberTriviaRemoteDataSourceImpl(chopperClient: chopperClient);
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJsonFactory(json.decode(fixture('trivia.json')));

    test(
      'should preform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        //arrange
        const String authority = 'numbersapi.com';
        final String path = tNumber.toString();
        var url = Uri.http(authority, path);

        setUpMockHttpClientSuccess200When(
            headers: {'Content-Type': 'application/json'}, url: url);
        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getConcreteNumberTrivia;
        // assert
        expect(
            () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJsonFactory(json.decode(fixture('trivia.json')));

    test(
      'should preform a GET request on a URL with *random* endpoint with application/json header',
      () async {
        //arrange
        const String authority = 'numbersapi.com';
        const String path = '/random';
        var url = Uri.http(authority, path);

        const headers = {'Content-Type': 'application/json'};
        setUpMockHttpClientSuccess200When(headers: headers, url: url);
        // act
        final result = await dataSource.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getRandomNumberTrivia;
        // assert
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
