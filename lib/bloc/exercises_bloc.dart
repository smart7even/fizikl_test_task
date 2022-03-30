import 'package:bloc/bloc.dart';
import 'package:fizikl_test_task/models/i_exercise.dart';
import 'package:fizikl_test_task/models/single_exercise.dart';
import 'package:fizikl_test_task/models/superset.dart';
import 'package:fizikl_test_task/repository/i_exercise_repository.dart';
import 'package:meta/meta.dart';

part 'exercises_event.dart';
part 'exercises_state.dart';

class ExercisesBloc extends Bloc<ExercisesEvent, ExercisesState> {
  final IExerciseRepository exerciseRepository;

  ExercisesBloc({required this.exerciseRepository})
      : super(ExercisesInitial()) {
    on<ExercisesLoadStarted>((event, emit) async {
      emit(ExercisesLoadInProgress());
      final exercises = await exerciseRepository.getExercises();
      emit(ExercisesLoadSuccess(exercises: exercises));
    });

    on<ExercisesItemReordered>(((event, emit) {
      var curState = state;
      if (curState is ExercisesLoadSuccess) {
        int newIndex = event.newIndex;
        int oldIndex = event.oldIndex;

        if (oldIndex < newIndex) {
          newIndex--;
        }

        if (oldIndex == newIndex) {
          return;
        }

        SingleExercise? reorderedExercise;

        List<IExercise> exercises = [...curState.exercises];

        int currentSearchIndex = -1;
        for (var exercise in exercises) {
          if (currentSearchIndex + exercise.count >= oldIndex) {
            if (exercise is Superset) {
              reorderedExercise =
                  exercise.exercises[oldIndex - currentSearchIndex - 1];
              exercise.exercises.removeAt(oldIndex - currentSearchIndex - 1);

              if (exercise.count == 1) {
                exercises[exercises.indexOf(exercise)] = exercise.exercises[0];
              } else if (exercise.count == 0) {
                exercises.remove(exercise);
              }

              break;
            } else if (exercise is SingleExercise) {
              reorderedExercise = exercise;
              exercises.remove(exercise);
              break;
            }
          } else {
            currentSearchIndex += exercise.count;
          }
        }

        if (reorderedExercise is SingleExercise) {
          int currentIndex = 0;
          List<IExercise> newExercises = [];

          int exercisesListIndex = 0;
          for (var exercise in exercises) {
            if (currentIndex + exercise.count >= newIndex) {
              if (exercise is Superset) {
                if (currentIndex + exercise.count == newIndex) {
                  newExercises.add(exercise);
                  newExercises.add(reorderedExercise);
                  currentIndex += exercise.count + reorderedExercise.count;
                } else {
                  final supersetExercises = [...exercise.exercises];
                  supersetExercises.insert(
                      newIndex - currentIndex, reorderedExercise);
                  final superset = Superset(exercises: supersetExercises);
                  newExercises.add(superset);
                  currentIndex += superset.count;
                }
              } else if (exercise is SingleExercise) {
                newExercises.add(exercise);
                newExercises.add(reorderedExercise);
              }
              break;
            } else {
              currentIndex += exercise.count;
              newExercises.add(exercise);
            }

            exercisesListIndex++;
          }

          for (int i = exercisesListIndex + 1; i < exercises.length; i++) {
            newExercises.add(exercises[i]);
          }

          emit(ExercisesLoadSuccess(exercises: newExercises));
        }
      }
    }));
  }
}
