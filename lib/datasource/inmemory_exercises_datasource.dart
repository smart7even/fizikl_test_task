import 'package:fizikl_test_task/datasource/i_exercises_datasource.dart';
import 'package:fizikl_test_task/models/ordered_exercise.dart';

class InMemoryExercisesDatasource implements IExercisesDatasource {
  List<OrderedExercise> exercises;

  InMemoryExercisesDatasource({required this.exercises});

  @override
  Future<List<OrderedExercise>> getExercises() async {
    return exercises;
  }

  @override
  Future<void> saveExercises(List<OrderedExercise> exercises) async {
    this.exercises = exercises;
  }
}
