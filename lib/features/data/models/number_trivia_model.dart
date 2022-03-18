import '../../domain/entities/number_trivia.dart';
import 'package:json_annotation/json_annotation.dart';

part 'number_trivia_model.g.dart';

@JsonSerializable()
class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({
    required String text,
    required int number,
  }) : super(text: text, number: number);

  Map<String, dynamic> toJson() => _$NumberTriviaModelToJson(this);
  static const fromJsonFactory = _$NumberTriviaModelFromJson;

  /*factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'],
      number: (json['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }*/
}
