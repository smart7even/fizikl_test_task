import 'package:equatable/equatable.dart';
import 'package:fizikl_test_task/models/single_exercise.dart';

import 'i_exercise.dart';

class Superset extends Equatable implements IExercise {
  final List<SingleExercise> exercises;

  const Superset({
    required this.exercises,
  });

  @override
  List<Object?> get props => [exercises];

  @override
  int get count => exercises.length;

  @override
  IExercise copy() {
    return Superset(
      exercises: exercises.map((e) => e.copy() as SingleExercise).toList(),
    );
  }
}
