import 'package:fizikl_test_task/models/i_exercise.dart';
import 'package:fizikl_test_task/models/single_exercise.dart';
import 'package:fizikl_test_task/models/superset.dart';

class ExercisesReorderer {
  List<IExercise> reorder(
    List<IExercise> exercises,
    int oldIndex,
    int newIndex,
  ) {
    if (oldIndex < newIndex) {
      newIndex--;
    }

    if (oldIndex == newIndex) {
      return exercises;
    }

    SingleExercise? reorderedExercise = _findByExerciseIndex(
      exercises,
      oldIndex,
    );

    if (reorderedExercise is! SingleExercise) {
      throw ExercisesReorderException();
    }

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

    return newExercises;
  }

  SingleExercise? _findByExerciseIndex(List<IExercise> exercises, int index) {
    SingleExercise? reorderedExercise;

    int currentSearchIndex = -1;
    for (var exercise in exercises) {
      if (currentSearchIndex + exercise.count >= index) {
        if (exercise is Superset) {
          reorderedExercise =
              exercise.exercises[index - currentSearchIndex - 1];
          exercise.exercises.removeAt(index - currentSearchIndex - 1);

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

    return reorderedExercise;
  }
}

class ExercisesReorderException implements Exception {}
