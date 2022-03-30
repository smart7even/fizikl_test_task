import 'package:fizikl_test_task/datasource/inmemory_exercises_datasource.dart';
import 'package:fizikl_test_task/models/i_exercise.dart';
import 'package:fizikl_test_task/models/ordered_exercise.dart';
import 'package:fizikl_test_task/models/single_exercise.dart';
import 'package:fizikl_test_task/models/superset.dart';
import 'package:fizikl_test_task/repository/exercise_repository.dart';
import 'package:fizikl_test_task/repository/i_exercise_repository.dart';
import 'package:fizikl_test_task/services/exercises_mapper.dart';
import 'package:fizikl_test_task/widgets/exercise_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/exercises_bloc.dart';
import 'dart:math' as math;

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
              title: Text('Exercise planner'),
              elevation: 0,
            ),
            body: SafeArea(child: MyStatefulWidget())),
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

  final List<Color> colors = const [
    Color(0xFF10CF5C),
    Color(0xFF599CFF),
    Color(0xFFB2F28A),
    Color(0xFFC3FE1C),
    Color(0xFFC6FEE3),
    Color(0xFFF48484),
    Color(0xFFF49E4E),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExercisesBloc, ExercisesState>(
      builder: (context, state) {
        if (state is ExercisesInitial) {
          return LinearProgressIndicator();
        } else if (state is ExercisesLoadInProgress) {
          return LinearProgressIndicator();
        } else if (state is ExercisesLoadSuccess) {
          List<OrderedExercise> orderedExercises =
              ExercisesMapper.mapToOrderedExercises(state.exercises);

          return ReorderableListView.builder(
            proxyDecorator: (child, index, animation) {
              return child;
            },
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            itemBuilder: (context, index) {
              return ExerciseTile(
                  key: Key('Exercise ${orderedExercises[index].id}'),
                  title: 'Exercise ${orderedExercises[index].id}',
                  order: orderedExercises[index].order.toString(),
                  orderColor:
                      colors[orderedExercises[index].order % colors.length]);
            },
            onReorder: (int oldIndex, int newIndex) {
              BlocProvider.of<ExercisesBloc>(context).add(
                ExercisesItemReordered(oldIndex: oldIndex, newIndex: newIndex),
              );
            },
            itemCount: orderedExercises.length,
          );
        }

        return Text('Error');
      },
    );
  }
}
