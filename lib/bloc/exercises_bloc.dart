import 'dart:developer';
import 'dart:math' hide log;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fizikl_test_task/data/repository/exercise_repository_exceptions.dart';
import 'package:fizikl_test_task/data/repository/i_exercise_repository.dart';
import 'package:fizikl_test_task/models/i_exercise.dart';
import 'package:fizikl_test_task/models/ordered_exercise.dart';
import 'package:fizikl_test_task/models/single_exercise.dart';
import 'package:fizikl_test_task/models/superset.dart';
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

        final newState =
            curState.copyWith(exercises: [...curState.exercises, newExercise]);

        try {
          await exerciseRepository.saveExercises(newState.exercises);
          emit(ExercisesLoadSuccess(exercises: newState.exercises));
        } on ExercisesSaveFailedException {
          log('Error while saving exercises');
          emit(ExercisesSaveError(exercises: curState.exercises));
        }
      }
    });

    on<ExerciseDeletePressed>((event, emit) async {
      var curState = state;

      if (curState is ExercisesLoadSuccess) {
        List<OrderedExercise> orderedExercises =
            ExercisesMapper.mapToOrderedExercises(curState.exercises);
        for (int i = 0; i < orderedExercises.length; i++) {
          var exercise = orderedExercises[i];
          if (exercise.id == event.exerciseId) {
            orderedExercises.remove(exercise);
          }
        }

        final newExercises =
            ExercisesMapper.mapOrderedExercises(orderedExercises);

        try {
          await exerciseRepository.saveExercises(newExercises);
          emit(ExercisesLoadSuccess(exercises: newExercises));
        } on ExercisesSaveFailedException {
          log('Error while saving exercises');
          emit(ExercisesSaveError(exercises: curState.exercises));
        }
      }
    });

    on<ExerciseMergeUpPressed>(((event, emit) async {
      var curState = state;
      if (curState is ExercisesLoadSuccess) {
        curState = ExercisesLoadSuccess(
          exercises: curState.exercises.map((e) => e.copy()).toList(),
        );

        for (int i = 0; i < curState.exercises.length; i++) {
          IExercise exercise = curState.exercises[i];

          if (exercise is SingleExercise) {
            if (exercise.id == event.exerciseId) {
              if (i - 1 >= 0) {
                IExercise secondExercise = curState.exercises[i - 1];

                if (secondExercise is SingleExercise) {
                  curState.exercises.removeAt(i);
                  curState.exercises.removeAt(i - 1);
                  curState.exercises.insert(
                    i - 1,
                    Superset(
                      exercises: [
                        secondExercise,
                        exercise,
                      ],
                    ),
                  );
                } else if (secondExercise is Superset) {
                  curState.exercises.removeAt(i);
                  secondExercise.exercises.add(exercise);
                }
              }
            }
          }
        }

        try {
          await exerciseRepository.saveExercises(curState.exercises);
          emit(curState);
        } on ExercisesSaveFailedException {
          log('Error while saving exercises');
          emit(ExercisesSaveError(exercises: curState.exercises));
        }
      }
    }));

    on<ExerciseMergeDownPressed>(((event, emit) async {
      var curState = state;
      if (curState is ExercisesLoadSuccess) {
        curState = ExercisesLoadSuccess(
          exercises: curState.exercises.map((e) => e.copy()).toList(),
        );

        for (int i = 0; i < curState.exercises.length; i++) {
          IExercise exercise = curState.exercises[i];

          if (exercise is SingleExercise) {
            if (exercise.id == event.exerciseId) {
              if (i + 1 < curState.exercises.length) {
                IExercise secondExercise = curState.exercises[i + 1];

                if (secondExercise is SingleExercise) {
                  curState.exercises.removeAt(i + 1);
                  curState.exercises.removeAt(i);

                  curState.exercises.insert(
                    i,
                    Superset(
                      exercises: [
                        secondExercise,
                        exercise,
                      ],
                    ),
                  );
                } else if (secondExercise is Superset) {
                  curState.exercises.removeAt(i);
                  secondExercise.exercises.add(exercise);
                }
              }
            }
          }
        }

        try {
          await exerciseRepository.saveExercises(curState.exercises);
          emit(curState);
        } on ExercisesSaveFailedException {
          log('Error while saving exercises');
          emit(ExercisesSaveError(exercises: curState.exercises));
        }
      }
    }));

    on<SupersetMoveUpPressed>(((event, emit) async {
      var curState = state;

      if (curState is ExercisesLoadSuccess) {
        var exercises = curState.exercises.map((e) => e.copy()).toList();

        for (int i = 1; i < exercises.length; i++) {
          IExercise exercise = exercises[i];
          if (exercise is Superset) {
            if (exercise.exercises[0].id == event.exerciseId) {
              final replacedExercise = exercises[i - 1];

              exercises
                  .replaceRange(i - 1, i + 1, [exercise, replacedExercise]);
              break;
            }
          }
        }

        try {
          await exerciseRepository.saveExercises(exercises);
          emit(ExercisesLoadSuccess(exercises: exercises));
        } on ExercisesSaveFailedException {
          log('Error while saving exercises');
          emit(ExercisesSaveError(exercises: curState.exercises));
        }
      }
    }));

    on<SupersetMoveDownPressed>(((event, emit) async {
      var curState = state;

      if (curState is ExercisesLoadSuccess) {
        var exercises = curState.exercises.map((e) => e.copy()).toList();

        for (int i = 0; i < exercises.length - 1; i++) {
          IExercise exercise = exercises[i];
          if (exercise is Superset) {
            if (exercise.exercises[0].id == event.exerciseId) {
              final replacedExercise = exercises[i + 1];

              exercises.replaceRange(i, i + 2, [replacedExercise, exercise]);
              break;
            }
          }
        }

        try {
          await exerciseRepository.saveExercises(exercises);
          emit(ExercisesLoadSuccess(exercises: exercises));
        } on ExercisesSaveFailedException {
          log('Error while saving exercises');
          emit(ExercisesSaveError(exercises: curState.exercises));
        }
      }
    }));
  }
}
