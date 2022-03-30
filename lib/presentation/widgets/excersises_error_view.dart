import 'package:fizikl_test_task/bloc/exercises_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExercisesErrorView extends StatelessWidget {
  const ExercisesErrorView({
    Key? key,
    required this.errorText,
  }) : super(key: key);

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(errorText),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<ExercisesBloc>(context).add(
                ExercisesLoadStarted(),
              );
            },
            child: const Text('Try again'),
          )
        ],
      ),
    );
  }
}
