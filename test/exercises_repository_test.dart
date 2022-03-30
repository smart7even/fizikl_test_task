import 'package:fizikl_test_task/datasource/inmemory_exercises_datasource.dart';
import 'package:fizikl_test_task/models/i_exercise.dart';
import 'package:fizikl_test_task/models/ordered_exercise.dart';
import 'package:fizikl_test_task/models/single_exercise.dart';
import 'package:fizikl_test_task/models/superset.dart';
import 'package:fizikl_test_task/repository/exercise_repository.dart';
import 'package:flutter_test/flutter_test.dart';

final _defaultData = <Map<String, dynamic>>[
  {"id": 1, "order": 1, "order_prefix": ""},
  {"id": 2, "order": 2, "order_prefix": "a"},
  {"id": 3, "order": 2, "order_prefix": "b"},
  {"id": 4, "order": 2, "order_prefix": "c"},
  {"id": 5, "order": 3, "order_prefix": ""},
  {"id": 6, "order": 4, "order_prefix": "a"},
  {"id": 7, "order": 4, "order_prefix": "b"},
];

void main() {
  test('Exercises mapping successful', () async {
    ExerciseRepository exerciseRepository = ExerciseRepository(
      exercisesDataSource: InMemoryExercisesDatasource(
        exercises:
            _defaultData.map((e) => OrderedExercise.fromJson(e)).toList(),
      ),
    );
    List<IExercise> exercises = await exerciseRepository.getExercises();
    expect(
      exercises,
      equals(
        const [
          SingleExercise(id: 1),
          Superset(exercises: [
            SingleExercise(id: 2),
            SingleExercise(id: 3),
            SingleExercise(id: 4)
          ]),
          SingleExercise(id: 5),
          Superset(exercises: [
            SingleExercise(id: 6),
            SingleExercise(id: 7),
          ])
        ],
      ),
    );

    exercises.add(const Superset(exercises: [
      SingleExercise(id: 8),
      SingleExercise(id: 9),
    ]));
    exerciseRepository.saveExercises(exercises);

    exercises = await exerciseRepository.getExercises();
    expect(
      exercises,
      equals(
        [
          const SingleExercise(id: 1),
          const Superset(exercises: [
            SingleExercise(id: 2),
            SingleExercise(id: 3),
            SingleExercise(id: 4)
          ]),
          const SingleExercise(id: 5),
          const Superset(exercises: [
            SingleExercise(id: 6),
            SingleExercise(id: 7),
          ]),
          const Superset(exercises: [
            SingleExercise(id: 8),
            SingleExercise(id: 9),
          ])
        ],
      ),
    );
  });
}
