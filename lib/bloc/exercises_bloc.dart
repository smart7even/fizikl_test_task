import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:fizikl_test_task/models/i_exercise.dart';
import 'package:fizikl_test_task/repository/exercise_repository_exceptions.dart';
import 'package:fizikl_test_task/repository/i_exercise_repository.dart';
import 'package:fizikl_test_task/services/exercises_reorderer.dart';
import 'package:meta/meta.dart';

part 'exercises_event.dart';
part 'exercises_state.dart';

class ExercisesBloc extends Bloc<ExercisesEvent, ExercisesState> {
  final IExerciseRepository exerciseRepository;
  final ExercisesReorderer exercisesReorderer;

  ExercisesBloc({
    required this.exerciseRepository,
    required this.exercisesReorderer,
  }) : super(ExercisesInitial()) {
    on<ExercisesLoadStarted>((event, emit) async {
      emit(ExercisesLoadInProgress());

      try {
        final exercises = await exerciseRepository.getExercises();
        emit(ExercisesLoadSuccess(exercises: exercises));
      } on ExercisesLoadingFailedException {
        log('Error while loading tasks');
        emit(ExercisesLoadError());
      }
    });

    on<ExercisesItemReordered>(((event, emit) async {
      var curState = state;
      if (curState is ExercisesLoadSuccess) {
        try {
          final newExercises = exercisesReorderer.reorder(
            [...curState.exercises],
            event.oldIndex,
            event.newIndex,
          );
          await exerciseRepository.saveExercises(newExercises);
          emit(ExercisesLoadSuccess(exercises: newExercises));
        } on ExercisesReorderException {
          log('Error while reordering tasks');
          emit(ExercisesReorderError());
        } on ExercisesSaveFailedException {
          log('Error while saving reordered tasks');
          emit(ExercisesReorderError());
        }
      }
    }));
  }
}
