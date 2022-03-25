import 'package:fizikl_test_task/datasource/i_exercises_datasource.dart';
import 'package:fizikl_test_task/models/i_exercise.dart';
import 'package:fizikl_test_task/models/ordered_exercise.dart';
import 'package:fizikl_test_task/models/single_exercise.dart';
import 'package:fizikl_test_task/models/superset.dart';
import 'package:fizikl_test_task/repository/i_exercise_repository.dart';

class ExerciseRepository implements IExerciseRepository {
  final IExercisesDatasource _exercisesDataSource;

  ExerciseRepository({required IExercisesDatasource exercisesDataSource})
      : _exercisesDataSource = exercisesDataSource;

  @override
  Future<List<IExercise>> getExercises() async {
    Iterable<OrderedExercise> orderedExercises =
        await _exercisesDataSource.getExercises();
    return _mapOrderedExercises(orderedExercises);
  }

  List<IExercise> _mapOrderedExercises(
      Iterable<OrderedExercise> orderedExercises) {
    final result = <IExercise>[];
    int order = 0;
    List<SingleExercise> exercisesBuffer = [];

    for (var entry in orderedExercises) {
      if (entry.order != order) {
        if (exercisesBuffer.length == 1) {
          result.add(exercisesBuffer.first);
        } else if (exercisesBuffer.length > 1) {
          result
              .add(Superset(exercises: exercisesBuffer.map((e) => e).toList()));
        }
        order = entry.order;
        exercisesBuffer.clear();
        exercisesBuffer.add(SingleExercise(id: entry.id));

        if (entry.id == orderedExercises.last.id) {
          result.add(exercisesBuffer.first);
        }
      } else {
        exercisesBuffer.add(SingleExercise(id: entry.id));

        if (entry.id == orderedExercises.last.id) {
          if (exercisesBuffer.length == 1) {
            result.add(exercisesBuffer.first);
          } else if (exercisesBuffer.length > 1) {
            result.add(
                Superset(exercises: exercisesBuffer.map((e) => e).toList()));
          }
        }
      }
    }

    return result;
  }

  List<OrderedExercise> _mapToOrderedExercises(List<IExercise> exercises) {
    List<OrderedExercise> orderedExercises = [];
    int order = 1;

    for (var exercise in exercises) {
      if (exercise is SingleExercise) {
        orderedExercises.add(
            OrderedExercise(id: exercise.id, order: order, orderPrefix: ''));
      } else if (exercise is Superset) {
        String orderPrefix = 'a';
        orderedExercises.addAll(exercise.exercises.map((e) {
          var exercise =
              OrderedExercise(id: e.id, order: order, orderPrefix: orderPrefix);
          orderPrefix = String.fromCharCode(orderPrefix.codeUnitAt(0) + 1);
          return exercise;
        }));
      }

      order++;
    }

    return orderedExercises;
  }

  @override
  Future<void> saveExercises(List<IExercise> exercises) async {
    _exercisesDataSource.saveExercises(_mapToOrderedExercises(exercises));
  }
}
