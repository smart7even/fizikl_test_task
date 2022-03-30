import 'package:fizikl_test_task/bloc/exercises_bloc.dart';
import 'package:fizikl_test_task/models/ordered_exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'exercise_tile.dart';

class ExercisesListView extends StatelessWidget {
  const ExercisesListView({
    Key? key,
    required this.orderedExercises,
    required this.colors,
    required this.buildDefaultDragHandles,
  }) : super(key: key);

  final List<OrderedExercise> orderedExercises;
  final List<Color> colors;
  final bool buildDefaultDragHandles;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ReorderableListView.builder(
          buildDefaultDragHandles: buildDefaultDragHandles,
          proxyDecorator: (child, index, animation) {
            return child;
          },
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          itemBuilder: (context, index) {
            final exercise = orderedExercises[index];
            return ExerciseTile(
              key: Key('Exercise ${exercise.id}'),
              id: exercise.id,
              order: exercise.order.toString(),
              orderColor: colors[exercise.order % colors.length],
              onDissmiss: (int id) {
                BlocProvider.of<ExercisesBloc>(context).add(
                  ExerciseDeletePressed(exerciseId: id),
                );
              },
            );
          },
          onReorder: (int oldIndex, int newIndex) {
            BlocProvider.of<ExercisesBloc>(context).add(
              ExercisesItemReordered(oldIndex: oldIndex, newIndex: newIndex),
            );
          },
          itemCount: orderedExercises.length,
        ),
        Positioned(
          right: 15,
          bottom: 15,
          child: FloatingActionButton(
            onPressed: () {
              BlocProvider.of<ExercisesBloc>(context)
                  .add(ExercisesAddPressed());
            },
            child: const Icon(Icons.add),
          ),
        )
      ],
    );
  }
}
