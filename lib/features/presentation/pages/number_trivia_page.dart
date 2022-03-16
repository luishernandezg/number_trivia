import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:number_trivia/injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';
import '../widgets/trivia_controls.dart';
import '../widgets/trivia_display.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Number Trivia'),
        ),
        body: buildBody(context));
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              // Top half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state.status == FormzStatus.pure) {
                    return const MessageDisplay(
                      message: 'Start searching!',
                    );
                  } else if (state.status == FormzStatus.submissionInProgress) {
                    return const LoadingWidget();
                  } else if (state.status == FormzStatus.submissionSuccess) {
                    return TriviaDisplay(
                      numberTrivia: state.trivia!,
                    );
                  } else if (state.status == FormzStatus.submissionFailure) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  }
                  return Container();
                  // We're going to also check for the other states
                },
              ),
              const SizedBox(height: 20),
              // Bottom half
              const TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}
