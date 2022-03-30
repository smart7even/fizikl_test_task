import 'package:fizikl_test_task/bloc/exercises_bloc.dart';
import 'package:fizikl_test_task/models/ordered_exercise.dart';
import 'package:fizikl_test_task/presentation/widgets/exercises_list_view.dart';
import 'package:fizikl_test_task/presentation/widgets/inactive_exercises_list_view.dart';
import 'package:fizikl_test_task/services/exercises_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'excersises_error_view.dart';

class ExercisesList extends StatelessWidget {
  const ExercisesList({Key? key}) : super(key: key);

  final List<Color> colors = const [
    Color(0xFF10CF5C),
    Color(0xFF599CFF),
    Color(0xFFB2F28A),
    Color(0xFFC3FE1C),
    Color(0xFFC6FEE3),
    Color(0xFFF48484),
    Color(0xFFF49E4E),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExercisesBloc, ExercisesState>(
      builder: (context, state) {
        if (state is ExercisesLoadSuccess) {
          List<OrderedExercise> orderedExercises =
              ExercisesMapper.mapToOrderedExercises(state.exercises);

          return ExercisesListView(
            orderedExercises: orderedExercises,
            colors: colors,
            buildDefaultDragHandles: true,
          );
        } else if (state is ExercisesSaveError) {
          List<OrderedExercise> orderedExercises =
              ExercisesMapper.mapToOrderedExercises(state.exercises);

          return InactiveExercisesListView(
              orderedExercises: orderedExercises, colors: colors);
        } else if (state is ExercisesInitial ||
            state is ExercisesLoadInProgress) {
          return const LinearProgressIndicator();
        } else if (state is ExercisesLoadError) {
          return const ExercisesErrorView(
            errorText: 'Exercises loading error',
          );
        } else if (state is ExercisesReorderError) {
          return const ExercisesErrorView(
            errorText:
                'Exercises reordering error. Try to load exercises again',
          );
        }

        return const Text('Error');
      },
    );
  }
}
