import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:number_trivia/core/chopper/json_type_parser.dart';
import 'package:number_trivia/features/data/models/error/response_error.dart';

class JsonSerializableConverter extends JsonConverter {
  @override
  Response<ResultType> convertResponse<ResultType, Item>(Response response) {
    final jsonRes = super.convertResponse<dynamic, dynamic>(response);
    if (jsonRes.body == null ||
        (jsonRes.body is String && (jsonRes.body as String).isEmpty)) {
      return jsonRes.copyWith(body: null);
    }
    final dynamic body = jsonRes.body;
    if (kDebugMode) {
      print('RESPONSE: $body');
    }
    final dynamic decodedItem = JsonTypeParser.decode<Item>(body);
    return jsonRes.copyWith<ResultType>(body: decodedItem as ResultType);
  }

  @override
  // We won't be dealing with toJson methods for now...
  Request convertRequest(Request request) => super.convertRequest(request);

  @override
  Response convertError<BodyType, InnerType>(Response response) {
    final jsonRes = super.convertError<BodyType, InnerType>(response);
    final dynamic body = jsonRes.body;
    if (kDebugMode) {
      print('ERROR_RESPONSE: $body');
    }
    final dynamic responseError = JsonTypeParser.decode<ResponseError>(body);
    return jsonRes.copyWith<BodyType>(bodyError: responseError as BodyType);
  }
}
