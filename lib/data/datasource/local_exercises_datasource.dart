import 'dart:convert';

import 'package:fizikl_test_task/data/datasource/i_exercises_datasource.dart';
import 'package:fizikl_test_task/models/ordered_exercise.dart';
import 'package:hive_flutter/adapters.dart';

class LocalExercisesDataSource implements IExercisesDatasource {
  final Box appBox;

  LocalExercisesDataSource(this.appBox);

  static const exercisesKey = 'exercises';

  @override
  Future<List<OrderedExercise>> getExercises() async {
    String? exercises = appBox.get(exercisesKey);

    if (exercises != null) {
      return (jsonDecode(exercises) as List<dynamic>)
          .map((e) => OrderedExercise.fromJson(e))
          .toList();
    }

    return [];
  }

  @override
  Future<void> saveExercises(List<OrderedExercise> exercises) async {
    await appBox.put(
      exercisesKey,
      jsonEncode(
        exercises
            .map(
              (e) => e.toJson(),
            )
            .toList(),
      ),
    );
  }
}
