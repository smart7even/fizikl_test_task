import 'package:equatable/equatable.dart';
import 'package:fizikl_test_task/models/i_exercise.dart';

class SingleExercise extends Equatable implements IExercise {
  final int id;

  SingleExercise({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}
