import 'package:formz/formz.dart';

enum InputNumberTriviaValidationError { empty }

class InputNumberTrivia
    extends FormzInput<String, InputNumberTriviaValidationError> {
  const InputNumberTrivia.pure() : super.pure('');
  const InputNumberTrivia.dirty([String value = '']) : super.dirty(value);

  @override
  InputNumberTriviaValidationError? validator(String? value) {
    return value?.isNotEmpty == true
        ? null
        : InputNumberTriviaValidationError.empty;
  }
}
