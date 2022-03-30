import 'package:fizikl_test_task/bloc/exercises_bloc.dart';
import 'package:fizikl_test_task/services/exercises_reorderer.dart';
import 'package:fizikl_test_task/widgets/exercises_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExercisesPage extends StatelessWidget {
  const ExercisesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExercisesBloc>(
      create: (ctx) {
        final bloc = ExercisesBloc(
          exerciseRepository: RepositoryProvider.of(ctx),
          exercisesReorderer: ExercisesReorderer(),
        );
        bloc.add(ExercisesLoadStarted());
        return bloc;
      },
      child: const ExercisesListView(),
    );
  }
}
