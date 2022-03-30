import 'package:fizikl_test_task/datasource/i_exercises_datasource.dart';
import 'package:fizikl_test_task/models/i_exercise.dart';
import 'package:fizikl_test_task/models/ordered_exercise.dart';
import 'package:fizikl_test_task/repository/i_exercise_repository.dart';
import 'package:fizikl_test_task/services/exercises_mapper.dart';

class ExerciseRepository implements IExerciseRepository {
  final IExercisesDatasource _exercisesDataSource;

  ExerciseRepository({required IExercisesDatasource exercisesDataSource})
      : _exercisesDataSource = exercisesDataSource;

  @override
  Future<List<IExercise>> getExercises() async {
    Iterable<OrderedExercise> orderedExercises =
        await _exercisesDataSource.getExercises();
    return ExercisesMapper.mapOrderedExercises(orderedExercises);
  }

  @override
  Future<void> saveExercises(List<IExercise> exercises) async {
    _exercisesDataSource.saveExercises(
      ExercisesMapper.mapToOrderedExercises(exercises),
    );
  }
}
