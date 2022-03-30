import 'package:fizikl_test_task/bloc/exercises_bloc.dart';
import 'package:fizikl_test_task/models/ordered_exercise.dart';
import 'package:fizikl_test_task/services/exercises_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'exercise_tile.dart';

class ExercisesListView extends StatelessWidget {
  const ExercisesListView({Key? key}) : super(key: key);

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
        if (state is ExercisesInitial) {
          return const LinearProgressIndicator();
        } else if (state is ExercisesLoadInProgress) {
          return const LinearProgressIndicator();
        } else if (state is ExercisesLoadError) {
          return const ExercisesErrorView(
            errorText:
                'Exercises reordering error. Try to load exercises again',
          );
        } else if (state is ExercisesReorderError) {
          return const ExercisesErrorView(
            errorText:
                'Exercises reordering error. Try to load exercises again',
          );
        } else if (state is ExercisesSaveError) {
          List<OrderedExercise> orderedExercises =
              ExercisesMapper.mapToOrderedExercises(state.exercises);

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
                child: ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  proxyDecorator: (child, index, animation) {
                    return child;
                  },
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  itemBuilder: (context, index) {
                    return ExerciseTile(
                        key: Key('Exercise ${orderedExercises[index].id}'),
                        title: 'Exercise ${orderedExercises[index].id}',
                        order: orderedExercises[index].order.toString(),
                        orderColor: colors[
                            orderedExercises[index].order % colors.length]);
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    BlocProvider.of<ExercisesBloc>(context).add(
                      ExercisesItemReordered(
                          oldIndex: oldIndex, newIndex: newIndex),
                    );
                  },
                  itemCount: orderedExercises.length,
                ),
              ),
            ],
          );
        } else if (state is ExercisesLoadSuccess) {
          List<OrderedExercise> orderedExercises =
              ExercisesMapper.mapToOrderedExercises(state.exercises);

          return ReorderableListView.builder(
            proxyDecorator: (child, index, animation) {
              return child;
            },
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            itemBuilder: (context, index) {
              return ExerciseTile(
                  key: Key('Exercise ${orderedExercises[index].id}'),
                  title: 'Exercise ${orderedExercises[index].id}',
                  order: orderedExercises[index].order.toString(),
                  orderColor:
                      colors[orderedExercises[index].order % colors.length]);
            },
            onReorder: (int oldIndex, int newIndex) {
              BlocProvider.of<ExercisesBloc>(context).add(
                ExercisesItemReordered(oldIndex: oldIndex, newIndex: newIndex),
              );
            },
            itemCount: orderedExercises.length,
          );
        }

        return const Text('Error');
      },
    );
  }
}

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
