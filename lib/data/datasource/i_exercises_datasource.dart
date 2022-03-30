import 'package:fizikl_test_task/models/ordered_exercise.dart';

abstract class IExercisesDatasource {
  Future<List<OrderedExercise>> getExercises();
  Future<void> saveExercises(List<OrderedExercise> exercises);
}
