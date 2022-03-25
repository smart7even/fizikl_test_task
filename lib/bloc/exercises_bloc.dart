import 'package:bloc/bloc.dart';
import 'package:fizikl_test_task/models/i_exercise.dart';
import 'package:fizikl_test_task/repository/i_exercise_repository.dart';
import 'package:meta/meta.dart';

part 'exercises_event.dart';
part 'exercises_state.dart';

class ExercisesBloc extends Bloc<ExercisesEvent, ExercisesState> {
  final IExerciseRepository exerciseRepository;

  ExercisesBloc({required this.exerciseRepository})
      : super(ExercisesInitial()) {
    on<ExercisesLoadStarted>((event, emit) async {
      emit(ExercisesLoadInProgress());
      final exercises = await exerciseRepository.getExercises();
      emit(ExercisesLoadSuccess(exercises: exercises));
    });

    on<ExercisesItemReordered>(((event, emit) {}));
  }
}
