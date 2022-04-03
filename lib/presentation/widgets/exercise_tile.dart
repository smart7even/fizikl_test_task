import 'package:flutter/material.dart';

import 'exercise_tile_arrow_buttons.dart';

enum ExerciseTileButtonsType { disabled, merge, moveSuperset }

class ExerciseTile extends StatelessWidget {
  const ExerciseTile(
      {Key? key,
      required this.id,
      required this.order,
      required this.orderColor,
      required this.onDissmiss,
      required this.onAboveClick,
      required this.onBelowClick,
      required this.buttonsType})
      : super(key: key);

  final int id;
  final String order;
  final Color orderColor;
  final Function(int id) onDissmiss;
  final Function(int id) onAboveClick;
  final Function(int id) onBelowClick;
  final ExerciseTileButtonsType buttonsType;

  Widget _buildButtons() {
    if (buttonsType == ExerciseTileButtonsType.disabled) {
      return const SizedBox.shrink();
    }

    return ExerciceTileArrowButtons(
        onAboveClick: onAboveClick,
        id: id,
        buttonsType: buttonsType,
        onBelowClick: onBelowClick);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(id.toString()),
      onDismissed: (direction) {
        onDissmiss(id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: const BoxConstraints(maxHeight: 52),
        decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: orderColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    'Set $order',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exercise $id',
                    ),
                  ],
                ),
              ],
            ),
            _buildButtons()
          ],
        ),
      ),
    );
  }
}
