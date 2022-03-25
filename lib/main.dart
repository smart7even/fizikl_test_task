import 'package:fizikl_test_task/datasource/inmemory_exercises_datasource.dart';
import 'package:fizikl_test_task/models/i_exercise.dart';
import 'package:fizikl_test_task/models/ordered_exercise.dart';
import 'package:fizikl_test_task/models/single_exercise.dart';
import 'package:fizikl_test_task/models/superset.dart';
import 'package:fizikl_test_task/repository/exercise_repository.dart';
import 'package:fizikl_test_task/repository/i_exercise_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/exercises_bloc.dart';

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
            ].map((e) => OrderedExercise.fromJson(e)).toList(),
          ),
        ),
        child: const Scaffold(body: SafeArea(child: MyStatefulWidget())),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final List<int> _items = List<int>.generate(50, (int index) => index);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExercisesBloc>(
      create: (ctx) {
        final bloc =
            ExercisesBloc(exerciseRepository: RepositoryProvider.of(ctx));
        bloc.add(ExercisesLoadStarted());
        return bloc;
      },
      child: ExercisesListView(),
    );
  }
}

class ExercisesListView extends StatelessWidget {
  const ExercisesListView({Key? key}) : super(key: key);

  List<Widget> _buildExercises(List<IExercise> exercises) {
    final exercisesWidgets = <Widget>[];
    int supersetsCounter = 1;

    for (int index = 0; index < exercises.length; index += 1) {
      final exercise = exercises[index];

      if (exercise is SingleExercise) {
        exercisesWidgets.add(ListTile(
          contentPadding: EdgeInsets.only(left: 0),
          leading: ReorderableDragStartListener(
            key: Key('$index'),
            index: index,
            child: const Icon(Icons.drag_indicator),
          ),
          key: Key('${exercise.id}'),
          title: Text('Exercise ${exercise.id}'),
        ));
      } else if (exercise is Superset) {
        exercisesWidgets.add(ListTile(
          contentPadding: EdgeInsets.only(left: 3),
          title: Text('Superset $supersetsCounter',
              style: TextStyle(fontSize: 20)),
          key: Key('superset-$supersetsCounter'),
        ));
        supersetsCounter++;

        for (var singleExercise in exercise.exercises) {
          exercisesWidgets.add(ListTile(
            contentPadding: EdgeInsets.only(left: 20),
            leading: ReorderableDragStartListener(
                key: Key('${singleExercise.id}'),
                index: index,
                child: const Icon(Icons.drag_indicator)),
            key: Key('${singleExercise.id}'),
            title: Text('Exercise ${singleExercise.id}'),
          ));
        }
      }
    }

    return exercisesWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExercisesBloc, ExercisesState>(
      builder: (context, state) {
        if (state is ExercisesInitial) {
          return LinearProgressIndicator();
        } else if (state is ExercisesLoadInProgress) {
          return LinearProgressIndicator();
        } else if (state is ExercisesLoadSuccess) {
          return ReorderableListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: _buildExercises(state.exercises),
            onReorder: (int oldIndex, int newIndex) {
              debugPrint(oldIndex.toString());
              debugPrint(newIndex.toString());
              // setState(() {
              //   if (oldIndex < newIndex) {
              //     newIndex -= 1;
              //   }
              //   final int item = _items.removeAt(oldIndex);
              //   _items.insert(newIndex, item);
              // });
            },
          );
        }

        return Text('Error');
      },
    );
  }
}
