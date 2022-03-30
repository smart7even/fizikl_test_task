import 'package:fizikl_test_task/models/i_exercise.dart';

abstract class IExerciseRepository {
  Future<List<IExercise>> getExercises();
  Future<void> saveExercises(List<IExercise> exercises);
}
