part of 'exercises_bloc.dart';

@immutable
abstract class ExercisesState {}

class ExercisesInitial extends ExercisesState {}

class ExercisesLoadInProgress extends ExercisesState {}

class ExercisesLoadSuccess extends ExercisesState {
  final List<IExercise> exercises;

  ExercisesLoadSuccess({
    required this.exercises,
  });
}

class ExercisesLoadError {}
