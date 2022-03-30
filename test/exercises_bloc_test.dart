import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

import 'package:fizikl_test_task/bloc/exercises_bloc.dart';
import 'package:fizikl_test_task/data/datasource/inmemory_exercises_datasource.dart';
import 'package:fizikl_test_task/data/repository/exercise_repository.dart';
import 'package:fizikl_test_task/models/ordered_exercise.dart';
import 'package:fizikl_test_task/models/single_exercise.dart';
import 'package:fizikl_test_task/models/superset.dart';
import 'package:fizikl_test_task/services/exercises_reorderer.dart';

void main() {
  group(
    'exercises reordering',
    () {
      late ExercisesBloc exercisesBloc;

      setUp(() {
        exercisesBloc = ExercisesBloc(
          exerciseRepository: ExerciseRepository(
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
          exercisesReorderer: ExercisesReorderer(),
        );
      });

      test('initial state is initial', () {
        expect(exercisesBloc.state is ExercisesInitial, equals(true));
      });

      blocTest<ExercisesBloc, ExercisesState>(
        'emits [ExercisesLoadingInProgress, ExercisesLoadSuccess] when ExercisesLoadingStarted added',
        build: () => exercisesBloc,
        act: (bloc) => bloc.add(ExercisesLoadStarted()),
        expect: () => [
          ExercisesLoadInProgress(),
          ExercisesLoadSuccess(exercises: const [
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
          ])
        ],
      );

      blocTest<ExercisesBloc, ExercisesState>(
        'moving exercise after superset doesn\'t add it to superset',
        build: () => exercisesBloc,
        act: (bloc) {
          bloc.add(ExercisesLoadStarted());
          bloc.add(ExercisesItemReordered(oldIndex: 0, newIndex: 4));
        },
        expect: () => [
          ExercisesLoadInProgress(),
          ExercisesLoadSuccess(exercises: const [
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
          ]),
          ExercisesLoadSuccess(exercises: const [
            Superset(exercises: [
              SingleExercise(id: 2),
              SingleExercise(id: 3),
              SingleExercise(id: 4)
            ]),
            SingleExercise(id: 1),
            SingleExercise(id: 5),
            Superset(exercises: [
              SingleExercise(id: 6),
              SingleExercise(id: 7),
            ])
          ]),
        ],
      );

      blocTest<ExercisesBloc, ExercisesState>(
        'moving exercise before superset doesn\'t add it to superset',
        build: () => exercisesBloc,
        act: (bloc) {
          bloc.add(ExercisesLoadStarted());
          bloc.add(ExercisesItemReordered(oldIndex: 0, newIndex: 5));
        },
        expect: () => [
          ExercisesLoadInProgress(),
          ExercisesLoadSuccess(exercises: const [
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
          ]),
          ExercisesLoadSuccess(exercises: const [
            Superset(exercises: [
              SingleExercise(id: 2),
              SingleExercise(id: 3),
              SingleExercise(id: 4)
            ]),
            SingleExercise(id: 5),
            SingleExercise(id: 1),
            Superset(exercises: [
              SingleExercise(id: 6),
              SingleExercise(id: 7),
            ])
          ]),
        ],
      );

      blocTest<ExercisesBloc, ExercisesState>(
        'moving exercise between superset edge exercises adds it to superset',
        build: () => exercisesBloc,
        act: (bloc) {
          bloc.add(ExercisesLoadStarted());
          bloc.add(ExercisesItemReordered(oldIndex: 0, newIndex: 3));
        },
        expect: () => [
          ExercisesLoadInProgress(),
          ExercisesLoadSuccess(exercises: const [
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
          ]),
          ExercisesLoadSuccess(exercises: const [
            Superset(exercises: [
              SingleExercise(id: 2),
              SingleExercise(id: 3),
              SingleExercise(id: 1),
              SingleExercise(id: 4)
            ]),
            SingleExercise(id: 5),
            Superset(exercises: [
              SingleExercise(id: 6),
              SingleExercise(id: 7),
            ])
          ]),
        ],
      );

      blocTest<ExercisesBloc, ExercisesState>(
        'adding new exercise works correctly',
        build: () => exercisesBloc,
        act: (bloc) {
          bloc.add(ExercisesLoadStarted());
          bloc.add(ExercisesAddPressed());
        },
        expect: () => [
          ExercisesLoadInProgress(),
          ExercisesLoadSuccess(exercises: const [
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
          ]),
          ExercisesLoadSuccess(exercises: const [
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
            ]),
            SingleExercise(id: 8),
          ])
        ],
      );

      blocTest<ExercisesBloc, ExercisesState>(
        'delete single exercise works correctly',
        build: () => exercisesBloc,
        act: (bloc) {
          bloc.add(ExercisesLoadStarted());
          bloc.add(ExerciseDeletePressed(exerciseId: 5));
        },
        expect: () => [
          ExercisesLoadInProgress(),
          ExercisesLoadSuccess(exercises: const [
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
          ]),
          ExercisesLoadSuccess(exercises: const [
            SingleExercise(id: 1),
            Superset(exercises: [
              SingleExercise(id: 2),
              SingleExercise(id: 3),
              SingleExercise(id: 4)
            ]),
            Superset(exercises: [
              SingleExercise(id: 6),
              SingleExercise(id: 7),
            ]),
          ])
        ],
      );

      blocTest<ExercisesBloc, ExercisesState>(
        'delete exercise from superset works correctly',
        build: () => exercisesBloc,
        act: (bloc) {
          bloc.add(ExercisesLoadStarted());
          bloc.add(ExerciseDeletePressed(exerciseId: 3));
        },
        expect: () => [
          ExercisesLoadInProgress(),
          ExercisesLoadSuccess(exercises: const [
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
          ]),
          ExercisesLoadSuccess(exercises: const [
            SingleExercise(id: 1),
            Superset(exercises: [
              SingleExercise(id: 2),
              SingleExercise(id: 4),
            ]),
            SingleExercise(id: 5),
            Superset(exercises: [
              SingleExercise(id: 6),
              SingleExercise(id: 7),
            ]),
          ])
        ],
      );
    },
  );
}
