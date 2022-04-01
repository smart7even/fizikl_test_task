part of 'exercises_bloc.dart';

@immutable
abstract class ExercisesEvent {}

class ExercisesLoadStarted implements ExercisesEvent {}

class ExercisesItemReordered implements ExercisesEvent {
  final int oldIndex;
  final int newIndex;

  ExercisesItemReordered({
    required this.oldIndex,
    required this.newIndex,
  });
}

class ExercisesSavePressed implements ExercisesEvent {}

class ExercisesAddPressed implements ExercisesEvent {}

class ExerciseDeletePressed implements ExercisesEvent {
  final int exerciseId;

  ExerciseDeletePressed({
    required this.exerciseId,
  });
}

class ExerciseMergeUpPressed implements ExercisesEvent {
  final int exerciseId;

  ExerciseMergeUpPressed({
    required this.exerciseId,
  });
}

class ExerciseMergeDownPressed implements ExercisesEvent {
  final int exerciseId;

  ExerciseMergeDownPressed({
    required this.exerciseId,
  });
}

class SupersetMoveUpPressed implements ExercisesEvent {
  final int exerciseId;

  SupersetMoveUpPressed({
    required this.exerciseId,
  });
}

class SupersetMoveDownPressed implements ExercisesEvent {
  final int exerciseId;

  SupersetMoveDownPressed({
    required this.exerciseId,
  });
}
