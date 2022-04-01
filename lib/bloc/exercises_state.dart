part of 'exercises_bloc.dart';

@immutable
abstract class ExercisesState {}

class ExercisesInitial extends ExercisesState {}

class ExercisesLoadInProgress extends ExercisesState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class ExercisesLoadSuccess extends ExercisesState with EquatableMixin {
  final List<IExercise> exercises;

  ExercisesLoadSuccess({
    required this.exercises,
  });

  ExercisesLoadSuccess copyWith({List<IExercise>? exercises}) {
    return ExercisesLoadSuccess(
      exercises: exercises ?? this.exercises,
    );
  }

  @override
  List<Object?> get props => [exercises];
}

class ExercisesLoadError extends ExercisesState {}

class ExercisesSaveError extends ExercisesState {
  final List<IExercise> exercises;

  ExercisesSaveError({
    required this.exercises,
  });
}

class ExercisesReorderError extends ExercisesState {}
