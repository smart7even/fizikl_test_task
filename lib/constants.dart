import 'models/ordered_exercise.dart';

const appBoxName = 'app';

const bool reinitializeStorage = false;
final mockData = [
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
].map((e) => OrderedExercise.fromJson(e)).toList();
