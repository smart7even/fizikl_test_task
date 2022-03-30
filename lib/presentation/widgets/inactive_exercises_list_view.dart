import 'package:fizikl_test_task/bloc/exercises_bloc.dart';
import 'package:fizikl_test_task/models/ordered_exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'exercises_list_view.dart';

class InactiveExercisesListView extends StatelessWidget {
  const InactiveExercisesListView({
    Key? key,
    required this.orderedExercises,
    required this.colors,
  }) : super(key: key);

  final List<OrderedExercise> orderedExercises;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                    'Unfortunately, your exercises are not syncronized with server. Please, establish your Internet connection and press "Save"'),
              ),
              TextButton.icon(
                onPressed: () {
                  BlocProvider.of<ExercisesBloc>(context).add(
                    ExercisesSavePressed(),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ExercisesListView(
            orderedExercises: orderedExercises,
            colors: colors,
            buildDefaultDragHandles: false,
          ),
        ),
      ],
    );
  }
}
