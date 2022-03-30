import 'dart:developer';
import 'dart:math' hide log;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fizikl_test_task/data/repository/exercise_repository_exceptions.dart';
import 'package:fizikl_test_task/data/repository/i_exercise_repository.dart';
import 'package:fizikl_test_task/models/i_exercise.dart';
import 'package:fizikl_test_task/models/ordered_exercise.dart';
import 'package:fizikl_test_task/models/single_exercise.dart';
import 'package:fizikl_test_task/services/exercises_mapper.dart';
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
            [...curState.exercises.map((e) => e.copy())],
            event.oldIndex,
            event.newIndex,
          );

          await exerciseRepository.saveExercises(newExercises);

          emit(ExercisesLoadSuccess(exercises: newExercises));
        } on ExercisesReorderException {
          log('Error while reordering exercises');
          emit(ExercisesReorderError());
        } on ExercisesSaveFailedException {
          log('Error while saving reordered exercises');
          emit(ExercisesSaveError(exercises: curState.exercises));
        }
      }
    }));

    on<ExercisesSavePressed>(((event, emit) async {
      var curState = state;

      if (curState is ExercisesSaveError) {
        try {
          await exerciseRepository.saveExercises(curState.exercises);
          emit(ExercisesLoadSuccess(exercises: curState.exercises));
        } on ExercisesSaveFailedException {
          log('Error while saving exercises');
          emit(ExercisesSaveError(exercises: curState.exercises));
        }
      }
    }));

    on<ExercisesAddPressed>((event, emit) async {
      var curState = state;

      if (curState is ExercisesLoadSuccess) {
        int maxId = 0;

        for (var exercise
            in ExercisesMapper.mapToOrderedExercises(curState.exercises)) {
          maxId = max(maxId, exercise.id);
        }

        int newExerciseId = maxId + 1;

        SingleExercise newExercise = SingleExercise(id: newExerciseId);

        emit(
            curState.copyWith(exercises: [...curState.exercises, newExercise]));
      }
    });

    on<ExerciseDeletePressed>((event, emit) {
      var curState = state;

      if (curState is ExercisesLoadSuccess) {
        List<OrderedExercise> orderedExercises =
            ExercisesMapper.mapToOrderedExercises(curState.exercises);
        for (var exercise in orderedExercises) {
          if (exercise.id == event.exerciseId) {
            orderedExercises.remove(exercise);
          }
        }

        emit(
          ExercisesLoadSuccess(
            exercises: ExercisesMapper.mapOrderedExercises(orderedExercises),
          ),
        );
      }
    });
  }
}
