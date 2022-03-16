import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String inputStr = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        BlocListener<NumberTriviaBloc, NumberTriviaState>(
          listener: (context, state) {
            if (state.status == FormzStatus.submissionFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
            }
            if (state.inputNumberTrivia.pure) {}
          },
          child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              buildWhen: (previous, current) =>
                  previous.inputNumberTrivia != current.inputNumberTrivia,
              builder: (context, state) {
                return TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Input a number',
                      errorText: state.inputNumberTrivia.invalid
                          ? 'invalid username'
                          : null),
                  controller: controller,
                  onChanged: (value) => context
                      .read<NumberTriviaBloc>()
                      .add(InputNumberChanged(value)),
                  onSubmitted: (_) => dispatchConcrete(),
                );
              }),
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                child: const Text('Search'),
                onPressed: dispatchConcrete,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                child: const Text('Get random trivia'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black87,
                    textStyle: const TextStyle(color: Colors.black)),
                onPressed: dispatchRandom,
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    // Clearing the TextField to prepare it for the next inputted number
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(const GetTriviaForConcreteNumber());
  }

  void dispatchRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}

class _NumberInput extends StatefulWidget {
  const _NumberInput({Key? key}) : super(key: key);

  @override
  State<_NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<_NumberInput> {
  final controller = TextEditingController();
  String inputStr = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<NumberTriviaBloc, NumberTriviaState>(
      listener: (context, state) {
        if (state.status == FormzStatus.submissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message)),
            );
        }
        if (state.inputNumberTrivia.pure) {}
      },
      child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
          buildWhen: (previous, current) =>
              previous.inputNumberTrivia != current.inputNumberTrivia,
          builder: (context, state) {
            return TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Input a number',
                  errorText: state.inputNumberTrivia.invalid
                      ? 'invalid username'
                      : null),
              controller: controller,
              onChanged: (value) => context
                  .read<NumberTriviaBloc>()
                  .add(InputNumberChanged(value)),
              onSubmitted: (_) => BlocProvider.of<NumberTriviaBloc>(context)
                  .add(const GetTriviaForConcreteNumber()),
            );
          }),
    );
  }
}

/*class _NumberInputState extends State<_NumberInput> {
  final controller = TextEditingController();
  String inputStr = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
        buildWhen: (previous, current) =>
        previous.inputNumberTrivia != current.inputNumberTrivia,
        builder: (context, state) {
          return TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Input a number',
                errorText: state.inputNumberTrivia.invalid
                    ? 'invalid username'
                    : null),
            controller: controller,
            onChanged: (value) =>
                context.read<NumberTriviaBloc>().add(InputNumberChanged(value)),
            onSubmitted: (_) => BlocProvider.of<NumberTriviaBloc>(context)
                .add(const GetTriviaForConcreteNumber()),
          );
        });
  }
}*/
