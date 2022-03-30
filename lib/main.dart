import 'package:fizikl_test_task/datasource/inmemory_exercises_datasource.dart';
import 'package:fizikl_test_task/models/ordered_exercise.dart';
import 'package:fizikl_test_task/pages/exercises_page.dart';
import 'package:fizikl_test_task/repository/exercise_repository.dart';
import 'package:fizikl_test_task/repository/i_exercise_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: RepositoryProvider<IExerciseRepository>(
        create: (context) => ExerciseRepository(
          exercisesDataSource: InMemoryExercisesDatasource(
            exercises: [
              {"id": 1, "order": 1, "order_prefix": ""},
              {"id": 2, "order": 2, "order_prefix": "a"},
              {"id": 3, "order": 2, "order_prefix": "b"},
              {"id": 4, "order": 2, "order_prefix": "c"},
              {"id": 5, "order": 3, "order_prefix": ""},
              {"id": 6, "order": 4, "order_prefix": "a"},
              {"id": 7, "order": 4, "order_prefix": "b"},
              {"id": 8, "order": 5, "order_prefix": ""},
              {"id": 9, "order": 6, "order_prefix": "a"},
              {"id": 10, "order": 6, "order_prefix": "b"},
              {"id": 11, "order": 6, "order_prefix": "c"},
              {"id": 12, "order": 7, "order_prefix": ""},
              {"id": 13, "order": 8, "order_prefix": "a"},
              {"id": 14, "order": 8, "order_prefix": "b"},
            ].map((e) => OrderedExercise.fromJson(e)).toList(),
          ),
        ),
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Exercise planner'),
              elevation: 0,
            ),
            body: const SafeArea(child: ExercisesPage())),
      ),
    );
  }
}
