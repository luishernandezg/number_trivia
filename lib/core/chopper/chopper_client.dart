import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia/core/chopper/json_serializable_convertor.dart';

class ChopperClientBuilder {
  static ChopperClient buildChopperClient(List<ChopperService> services,
          [http.BaseClient? httpClient]) =>
      ChopperClient(
          client: httpClient,
          baseUrl: 'http://numbersapi.com',
          services: services,
          interceptors: [
            (Request request) async =>
                request.copyWith(headers: {'Content-Type': 'application/json'}),
          ],
          converter: JsonSerializableConverter());
}
