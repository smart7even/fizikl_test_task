import 'package:fizikl_test_task/constants.dart';
import 'package:fizikl_test_task/data/datasource/local_exercises_datasource.dart';
import 'package:fizikl_test_task/data/repository/exercise_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/repository/i_exercise_repository.dart';
import 'presentation/pages/exercises_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(appBoxName);

  if (reinitializeStorage) {
    await Hive.deleteBoxFromDisk(appBoxName);
    await Hive.openBox(appBoxName);
    await LocalExercisesDataSource(Hive.box(appBoxName))
        .saveExercises(mockData);
  }

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
          exercisesDataSource: LocalExercisesDataSource(Hive.box(appBoxName)),
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
