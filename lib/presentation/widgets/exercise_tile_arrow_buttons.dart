import 'package:flutter/material.dart';

import 'exercise_tile.dart';

class ExerciceTileArrowButtons extends StatelessWidget {
  const ExerciceTileArrowButtons({
    Key? key,
    required this.id,
    required this.buttonsType,
    required this.onAboveClick,
    required this.onBelowClick,
  }) : super(key: key);

  final Function(int id) onAboveClick;
  final int id;
  final ExerciseTileButtonsType buttonsType;
  final Function(int id) onBelowClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          type: MaterialType.button,
          child: IconButton(
            padding: const EdgeInsets.all(5),
            onPressed: () {
              onAboveClick(id);
            },
            icon: Icon(
              Icons.arrow_upward,
              color: buttonsType == ExerciseTileButtonsType.merge
                  ? Colors.black
                  : Colors.blue,
            ),
            tooltip: buttonsType == ExerciseTileButtonsType.merge
                ? "Merge with exercise above"
                : "Move superset up",
          ),
        ),
        Material(
          color: Colors.transparent,
          child: IconButton(
            padding: const EdgeInsets.all(5),
            onPressed: () {
              onBelowClick(id);
            },
            icon: Icon(
              Icons.arrow_downward,
              color: buttonsType == ExerciseTileButtonsType.merge
                  ? Colors.black
                  : Colors.blue,
            ),
            tooltip: buttonsType == ExerciseTileButtonsType.merge
                ? "Merge with exercise below"
                : "Move superset down",
          ),
        )
      ],
    );
  }
}
